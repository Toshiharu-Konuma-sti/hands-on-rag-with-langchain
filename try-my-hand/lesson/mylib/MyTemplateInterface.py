import abc

class MyTemplateInterface(metaclass=abc.ABCMeta):

    test_context = """- 1:
\t- id: 141737
\t- category: 経済産業・社会,対面講座
\t- date: 2025-03-03
\t- title: ビジネスソフト実践科
\t- url: https://www.recurrent-navi.metro.tokyo.lg.jp/course/141737
\t- summary: コースの内容\\nWordやExcelをMOS資格取得レベルまで、またPowerPointの基礎も習得し、業務で活かせるスキルを身に付けます。オリジナルの教材と市販の教材を使用して基礎からしっかりステップアップしていきます。さらに、実務を想定した演習問題で実践力を養います。各種試験会場になっているので、慣れた環境で効率よく受験が可能です。就職支援ではキャリアコンサルタントが常駐しているので、就職相談、応募書類の添削や模擬面接も個別で随時対応します。また、採用実績のある企業の説明会等を実施します。訓練初期から就職に向けての行動計画を立て、スキルを習得しつつ就職に向けて早期に行動するよう促します。駅からも学校からも近い託児施設と契約しているため、希望者の方（条件有り）は安心してお子様を預けて学習に専念することができます。\n※本講座は3/3～5/30の期間を通じて行われます。
\t- 場所: 多摩・島しょ部,北多摩エリア,武蔵野市
\t- 主催者: 東京都（実施機関） 専門学校中野スクールオブビジネス
\t- 定員数: 30名
\t- 費用: 無料（別途、教科書代等は本人負担となります。）
\t- 申込期日: 2025年1月17日
- 2:
\t- id: 83980
\t- category: 経済産業・社会,対面講座
\t- date: 2025-03-08
\t- title: WordPressによるWebサイト制作
\t- url: https://www.recurrent-navi.metro.tokyo.lg.jp/course/83980
\t- summary: WordPressの概要、システムの構成、作業の概要、WordPressの設定、テーマ(テンプレート)の作成、プラグインの作成
\t- 場所: 23区,北区,城北エリア
\t- 主催者: 中央・城北職業能力開発センター赤羽校
\t- 定員数: 29名
\t- 費用: 6,500円
\t- 申込期日: 2024年12月10日
- 3:
\t- id: 111975
\t- category: 経済産業・社会,対面講座
\t- date: 2025-03-02
\t- title: ホームページビルダーによるホームページ作成
\t- url: https://www.recurrent-navi.metro.tokyo.lg.jp/course/111975
\t- summary: ホームページの基礎知識、Webサイトとトップページの作成および編集、リンクの設定、画像の作成と編集\n【ホーページビルダー21】
\t- 場所: 多摩・島しょ部,北多摩エリア,府中市
\t- 主催者: 多摩職業能力開発センター府中校
\t- 定員数: 25名
\t- 費用: 6,500円
\t- 申込期日: 2025年1月10日
- 4:
\t- id: 136726
\t- category: 経済産業・社会,オンライン講座,対面講座
\t- date: null
\t- title: 学校向け出前講座
\t- url: https://www.recurrent-navi.metro.tokyo.lg.jp/course/136726
\t- summary: 消費生活相談や商品テスト指導などの経験を積んだ東京都消費者啓発員（コンシューマー・エイド）が、悪質商法被害の実例に基づき、被害防止の方法・対策について、詳しく解説いたします。\n・契約とは何か／成年年齢引き下げに伴う消費者としての心得\n・悪質商法被害防止（マルチ商法・定期購入など）\n・インターネットやSNSのトラブル防止\n・お金の使い方（キャッシュレス、ローンやクレジットの仕組み）\n・糖度の測定（実験講座）
\t- 場所: オンライン,23区,多摩・島しょ部
\t- 主催者: 申込者
\t- 定員数: 原則 10名以上
\t- 費用: 無料
\t- 申込期日: 遅くても希望日の1か月前
"""

    test_question = "パソコンの使い方を学べるセミナーを教えてください"
    
    @abc.abstractmethod
    def get_template_for_use_retriever(self):
        raise NotImplementedError()
        
    @abc.abstractmethod
    def get_template_for_not_retriever(self):
        raise NotImplementedError()

    @abc.abstractmethod
    def extract_answer_from_response(self, response):
        raise NotImplementedError()

    @abc.abstractmethod
    def get_additional_template_for_conversation(self):
        raise NotImplementedError()

    def test_get_context(self):
        context_str = MyTemplateInterface.test_context
        context_str = context_str.replace('{', '{{')
        context_str = context_str.replace('}', '}}')
        return context_str

    def test_get_question(self):
        return MyTemplateInterface.test_question
