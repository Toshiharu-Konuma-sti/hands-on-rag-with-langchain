import torch
from transformers import (AutoModelForCausalLM, AutoTokenizer, pipeline)
from langchain_huggingface import HuggingFacePipeline
from langchain.prompts import PromptTemplate
from langchain.schema.runnable import RunnablePassthrough
import inspect

from mylib.MyTemplateImpl4Gemma import MyTemplateImpl4Gemma
from mylib.MyTemplateImpl4MsPhi import MyTemplateImpl4MsPhi
from mylib.MyTemplateImpl4OpenCalm import MyTemplateImpl4OpenCalm
from mylib.MyTemplateImpl4RinnaJpGpt import MyTemplateImpl4RinnaJpGpt
from mylib.MyTemplateImpl4Llama3 import MyTemplateImpl4Llama3

class MyGenerator:

    def __init__(self, model_name_list, access_token):
        my_method = inspect.currentframe().f_code.co_name
        prompts = {}
        for index, model_name in enumerate(model_name_list):
            print("\nStart @ [%s] >>> index=%d: [%s]" % (my_method, index, model_name))
            prompts[model_name] = {}
            prompts[model_name]["llm"] = self.__get_custom_llm(model_name, access_token)
            prompts[model_name]["template"] = self.__create_template(model_name)
        print("")
        self.prompts = prompts

    def create_chain(self, retriever, model_name, template = None):
        prompt = self.__get_prompt(model_name)
        if template is None:
            template = prompt["template"].get_template_for_use_retriever()
        template = PromptTemplate.from_template(template)
        chain = (
            {"context": retriever | MyGenerator.__format_docs, "question": RunnablePassthrough()}
            | template
            | prompt["llm"]
        )
        print(f"{model_name=}" + "\n" + ("-" * 30))
        print(f"{chain=}" + "\n" + ("-" * 30))
        return chain

    def create_chain_not_retriever(self, model_name, template = None):
        prompt = self.__get_prompt(model_name)
        if template is None:
            template = prompt["template"].get_template_for_not_retriever()
        template = PromptTemplate.from_template(template)
        chain = (
            {"question": RunnablePassthrough()}
            | template
            | prompt["llm"]
        )
        print(f"{model_name=}" + "\n" + ("-" * 30))
        print(f"{chain=}" + "\n" + ("-" * 30))
        return chain

    def extract_answer_from_response(self, model_name, response):
        prompt = self.__get_prompt(model_name)
        answer = prompt["template"].extract_answer_from_response(response)
        return answer

    def make_template_for_conversation(self, model_name, conversation):
        prompt = self.__get_prompt(model_name)
        addition = prompt["template"].get_additional_template_for_conversation()
        conversation = conversation.replace('{', '{{')
        conversation = conversation.replace('}', '}}')
        conversation += addition
        return conversation

    def get_template(self, model_name):
        prompt = self.__get_prompt(model_name)
        template = prompt["template"].get_template_for_use_retriever()
        return template

    def get_template_not_retriever(self, model_name):
        prompt = self.__get_prompt(model_name)
        template = prompt["template"].get_template_for_not_retriever()
        return template

    def __get_prompt(self, model_name):
        return self.prompts[model_name]

    # Replace similarity informations retrieved from vector db into a placeholder of context.
    @staticmethod
    def __format_docs(docs):
        return "* " + "\n* ".join(doc.page_content for doc in docs)

    def __get_custom_llm(self, trained_model_name, access_token):
        my_method = inspect.currentframe().f_code.co_name
        print(">>> 1/4[%s]: model = AutoModelForCausalLM.from_pretrained()" % (my_method))
        model = AutoModelForCausalLM.from_pretrained(
            trained_model_name,
            device_map = "auto",
            low_cpu_mem_usage = True,
            torch_dtype = "auto",
            trust_remote_code = True,
            token = access_token,
        )
        print(">>> 2/4[%s]: tokenizer = AutoTokenizer.from_pretrained()" % (my_method))
        tokenizer = AutoTokenizer.from_pretrained(
            trained_model_name,
            token = access_token
        )
        print(">>> 3/4[%s]: pipe = pipeline()" % (my_method))
        pipe = pipeline(
            'text-generation',
            model = model,
            tokenizer = tokenizer,
            max_new_tokens = 1024,
            torch_dtype = "auto",
        )
        print(">>> 4/4[%s]: llm = HuggingFacePipeline()" % (my_method))
        llm = HuggingFacePipeline(
            pipeline=pipe
        )
        return llm

    def __create_template(self, model_name):
        template = None;
        if 'google/gemma' in model_name:
            template = MyTemplateImpl4Gemma()
        elif 'microsoft/Phi' in model_name:
            template = MyTemplateImpl4MsPhi()
        elif 'cyberagent/open-calm' in model_name:
            template = MyTemplateImpl4OpenCalm()
        elif 'rinna/japanese-gpt' in model_name:
            template = MyTemplateImpl4RinnaJpGpt()
        elif 'meta-llama/Llama' in model_name:
            template = MyTemplateImpl4Llama3()
        return template
