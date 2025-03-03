
class MyOpenLlmList:

    trained_models = [
        'google/gemma-2b-it',   # 0
        'google/gemma-2-2b-it',   # 1
        'google/gemma-2-2b-jpn-it',   # 2
        'meta-llama/Llama-3.2-1B',  # 3
        'meta-llama/Llama-3.2-1B-Instruct', # 4
        'microsoft/Phi-3-mini-4k-instruct', # 5
        'microsoft/Phi-3-mini-128k-instruct', # 6
        'cyberagent/open-calm-small', # 7
        'cyberagent/open-calm-medium', # 8
        'cyberagent/open-calm-large', # 9
        'rinna/japanese-gpt2-medium', # 10
        'rinna/japanese-gpt-1b', # 11
        'rinna/japanese-gpt-neox-3.6b-instruction-sft-v2', # 12
        'lightblue/DeepSeek-R1-Distill-Qwen-1.5B-Multilingual', #13
    ]

    def __init__(self, enables = []):
        self.__printModelList("Initial list", self.trained_models)
        elements = self.trained_models
        if (len(enables) > 0):
            elements = [self.trained_models[i] for i in enables]
        self.trained_models = elements
        self.__printModelList("Enabled list", self.trained_models)

    def __printModelList(self, caption, models):
        print(f"{caption}:")
        for i, model in enumerate(models):
            print(f" {i}: {model}")

    def getAll(self):
        return self.trained_models

    def get(self, index):
        return self.trained_models[index]
