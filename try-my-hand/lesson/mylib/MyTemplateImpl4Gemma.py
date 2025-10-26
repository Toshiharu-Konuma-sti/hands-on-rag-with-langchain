from mylib.MyTemplateInterface import MyTemplateInterface
import re

class MyTemplateImpl4Gemma(MyTemplateInterface):

    def get_template_for_use_retriever(self):
        template = """<start_of_turn>system
あなたは親切で、礼儀正しく、誠実で優秀な日本人のアシスタントです。
context以下に箇条書きでお伝えする情報を使用してuserからの質問に回答してください。

context:
{context}<end_of_turn>
<start_of_turn>user
{question}<end_of_turn>
<start_of_turn>model"""
        return template

    def get_template_for_not_retriever(self):
        template = """<start_of_turn>system
あなたは親切で、礼儀正しく、誠実で優秀な日本人のアシスタントです。
userからの質問に回答してください。<end_of_turn>
<start_of_turn>user
{question}<end_of_turn>
<start_of_turn>model"""
        return template

    def extract_answer_from_response(self, response):
        answer = re.sub(".*<start_of_turn>model", "", response, flags=(re.DOTALL))
        answer = answer.strip()
        return answer

    def get_additional_template_for_conversation(self):
        template = """<end_of_turn>
<start_of_turn>user
{question}<end_of_turn>
<start_of_turn>model
"""
        return template
