from mylib.MyTemplateInterface import MyTemplateInterface
import re

class MyTemplateImpl4DeepSeek(MyTemplateInterface):

    def get_template_for_use_retriever(self):
        template = """<｜begin▁of▁sentence｜>
あなたは親切で、礼儀正しく、誠実で優秀な日本人のアシスタントです。
context以下に箇条書きでお伝えする情報を使用してuserからの質問に回答してください。

context:
{context}
<｜User｜>{question}
<｜Assistant｜>"""
        return template
        
    def get_template_for_not_retriever(self):
        template = """<｜begin▁of▁sentence｜>
あなたは親切で、礼儀正しく、誠実で優秀な日本人のアシスタントです。
userからの質問に回答してください。
<｜User｜>{question}
<｜Assistant｜>"""
        return template

    def extract_answer_from_response(self, response):
        answer = re.sub(".*<｜Assistant｜><think>", "", response, flags=(re.DOTALL))
        answer = answer.strip()
        return answer

    def get_additional_template_for_conversation(self):
        template = """<｜User｜>{question}
<｜Assistant｜>"""
        return template
