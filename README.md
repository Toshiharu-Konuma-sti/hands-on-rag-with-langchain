# Hands-on Training for RAG with LangChain

## ハンズオンの教材一覧

- [Step 1: 構造化データのVector DB登録](./try-my-hand/lesson/rag-step01-excel_to_vectordb.ipynb)
- [Step 2: Vector DBで類似検索](./try-my-hand/lesson/rag-step02-search_from_vectordb.ipynb)
- [Step 3: LLM Template作成](./try-my-hand/lesson/rag-step03-llm_template.ipynb)
- [Step 4: Retriever+Generator構築](./try-my-hand/lesson/rag-step04-retriever_and_generator.ipynb)
- [Step 5: Web UI (Chatting with Open LLM)](./try-my-hand/lesson/rag-step05-web_ui_to_chat_with_llm.ipynb)

## RAGの仕組み

<table>
<tr><th colspan="2">仕組みを表したイラスト</th><th></th></tr>
<tr><td width="50%"><img src="./try-my-hand/image/rag-overview.gif"><br>アニメーション版（流れを表現）</td><td  width="50%"><img src="./try-my-hand/image/rag-overview.png"><br>静止画版（全体像を表現）</td></tr>
<tr><th colspan="2">仕組みの流れを説明</th><th></th></tr>
<tr><td colspan="2">
1から2はベクトルデータベースに類似検索に利用するデータの蓄積フェーズを意味し、<br>3から9はベクトルデータベースに蓄積されたデータを類似検索で活用する応用フェーズを意味します。
<ol>
<li>日々の経済活動を通じて、以下をはじめとするデータが企業のシステムに溜まります<ul><li>販売する商品の在庫管理情報や売上データ</li><li>経済取引を記録する会計データ</li><li>企業に関わる人材を把握する社員情報や顧客情報</li><li>企画提案、商品説明、および企業説明等で作成されたドキュメントファイル
など</li></ul></li>
<li>企業に溜まったデータを検索に活用するために、以下をはじめとする加工を施しながらベクトル化して蓄積します<ul><li>検索効率が向上するサイズにデータを細切れに分割するチャンキング</li><li>ベクトルデータベースで類似検索が出来るように数値ベクトルに変換するエンベディング</li><li>必要に応じて検索効率を向上させるため欠損値の削除や補完、値形式を揃えるクレンジング</li></ul></li>
<li>日々の業務活動を進めるに当たり不明点があれば質問を投げかけます</li>
<li>投げかけられた質問をエンベディングしてベクトルデータベースに対して類似検索します</li>
<li>投げかけられた質問に関連するデータを類似検索結果として戻します</li>
<li>LLMに回答を生成を依頼するために、依頼向けテンプレートに質問と類似検索結果を付与してプロンプトを作成します</li>
<li>質問に回答するためにプロンプトを用いてLLMに回答案の作成を依頼します</li>
<li>LLMが生成された回答案を戻します</li>
<li>LLMから戻された回答案を整形して質問者に回答を戻します</li>
</ol>
</td><td></td></tr>
</table>






