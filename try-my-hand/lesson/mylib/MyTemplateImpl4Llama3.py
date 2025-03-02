from mylib.MyTemplateInterface import MyTemplateInterface
import re

class MyTemplateImpl4Llama3(MyTemplateInterface):

    def get_template_for_use_retriever(self):
        template = """<|start_header_id|>system<|end_header_id|>
あなたは親切で、礼儀正しく、誠実で優秀な日本人のアシスタントです。
context以下に箇条書きでお伝えする情報を使用してuserからの質問に回答してください。

context:
{context}<|eot_id|>
<|start_header_id|>user<|end_header_id|>
{question}<|eot_id|>
<|start_header_id|>assistant<|end_header_id|>"""
        return template
        
    def get_template_for_not_retriever(self):
        template = """<|start_header_id|>system<|end_header_id|>
あなたは親切で、礼儀正しく、誠実で優秀な日本人のアシスタントです。
userからの質問に回答してください。<|eot_id|>
<|start_header_id|>user<|end_header_id|>
{question}<|eot_id|>
<|start_header_id|>assistant<|end_header_id|>"""
        return template

    def extract_answer_from_response(self, response):
        answer = re.sub(".*<|start_header_id|>assistant<|end_header_id|>", "", response, flags=(re.DOTALL))
#        answer = re.sub("\|\|", "", answer, flags=(re.DOTALL))
        answer = answer.strip()
        return answer

    def get_additional_template_for_conversation(self):
        template = """<|eot_id|>
<|start_header_id|>user<|end_header_id|>
{question}<|eot_id|>
<|start_header_id|>assistant<|end_header_id|>"""
        return template
