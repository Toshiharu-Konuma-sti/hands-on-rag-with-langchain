from mylib.MyTemplateInterface import MyTemplateInterface
import re

class MyTemplateImpl4RinnaJpGpt(MyTemplateInterface):

    def get_template_for_use_retriever(self):
        template = """Q: {question}
以下の情報を参考に回答してください。
{context}
A: """
        return template

    def get_template_for_not_retriever(self):
        template = """Q: {question}
A: """
        return template

    def extract_answer_from_response(self, response):
        answer = re.sub(".*\nA:", "", response, flags=(re.DOTALL))
        answer = answer.strip()
        return answer

    def get_additional_template_for_conversation(self):
        template = """Q: {question}
A: """
        return template
