# voice-hook

Codex、Claude Code、Antigravityの応答が終わったとき、日本語の音声で知らせるmacOS向けの通知フックです。別の作業をしていても終了に気づけるように、アプリごとに違う声を使います。

アプリごとのシェルスクリプトと設定例、各アプリ3種類ずつの音声を同梱しています。通知のたびに、そのアプリの音声から1本をランダムに再生します。音声は収録済みなので、利用時にTTSモデルやAPIキーは必要ありません。

## 同梱している音声

| アプリ | 音声の特徴 |
| --- | --- |
| Codex | 気だるげで落ち着いた女性の声。「……お願いされた作業、終わったよ。確認してね。」など |
| Claude Code | 元気いっぱいのお嬢様口調の女性の声。「お待たせいたしましたわ！お願いされた作業、ばっちり終わりましたの！」など |
| Antigravity | 日本語で作業の終了を知らせる音声を3種類収録 |

### Codexのサンプル

<!-- CODEX_AUDIO_PLAYER: 公開時に previews/codex-stop-voice-01.mp4 をGitHubのREADME編集欄へ添付し、このコメントを生成された添付URLに置き換える。手順: docs/github-audio-preview.md -->

[WAVファイルを開く](voices/codex/codex-stop-voice-01.wav)

### Claude Codeのサンプル

<!-- CLAUDE_AUDIO_PLAYER: 公開時に previews/claude-stop-voice-01.mp4 をGitHubのREADME編集欄へ添付し、このコメントを生成された添付URLに置き換える。手順: docs/github-audio-preview.md -->

[WAVファイルを開く](voices/claude/claude-stop-voice-01.wav)

### Antigravityのサンプル

<!-- ANTIGRAVITY_AUDIO_PLAYER: 公開時に previews/antigravity-stop-voice-01.mp4 をGitHubのREADME編集欄へ添付し、このコメントを生成された添付URLに置き換える。手順: docs/github-audio-preview.md -->

[WAVファイルを開く](voices/antigravity/antigravity-stop-voice-01.wav)

ローカルで再生する手順は、下の「音声の確認」にあります。

通知のきっかけは、Codexではターンの完了イベント、Claude CodeとAntigravityでは`Stop`フックです。依頼した作業の成否を判定する機能はなく、アプリから終了イベントを受け取ったときに鳴ります。

## 必要な環境

- macOS（標準の`afplay`で音声を再生）
- Bash（`/bin/bash`を使用）
- `jq`（終了イベントのJSONを読み取るために使用）
- このMac上で動くCodex、Claude Code、またはAntigravity

`command -v jq`で`jq`の有無を確認できます。未インストールの場合、Homebrewを使用している環境では`brew install jq`で導入できます。アプリから実行されるフックの`PATH`にも、`jq`があるフォルダを含めてください。

## セットアップ

1. このフォルダを、音声通知に使うMacの任意の場所に置きます。
2. フォルダ内で`pwd`を実行し、このフォルダの絶対パスを確認します。
3. 使いたいアプリの設定例を、下記の設定ファイルに追加します。3アプリすべてを設定する必要はありません。
4. 設定例にある`/absolute/path/to/voice-hook`を、手順2で確認したパスに置き換えます。
5. 設定後、新しいセッションを開始します。反映されない場合はアプリを再起動します。

たとえば`pwd`の結果が`/Users/yourname/tools/voice-hook`なら、Codex用スクリプトのパスは`/Users/yourname/tools/voice-hook/scripts/codex-stop-voice.sh`です。各スクリプトは、そのアプリの音声フォルダを自動的に見つけます。

設定例は`configs/`にも保存しています。設定ファイルがない場合は作成してください。すでに設定がある場合は、ほかの設定を残したまま必要な項目を追加します。

### Codex

`~/.codex/config.toml`の最上位に、以下を追加します。TOMLの`[セクション名]`より前に置いてください。`notify`がすでにある場合は、同じキーを重複させず、値を更新します。

```toml
notify = ["/bin/bash", "/absolute/path/to/voice-hook/scripts/codex-stop-voice.sh"]
```

設定例のファイル：[configs/codex.toml](configs/codex.toml)

ほかの通知プログラムも使用している場合は、そのプログラムからこのスクリプトを呼び出すなど、1つの`notify`から両方を実行するようにします。

### Claude Code

`~/.claude/settings.json`に、以下の`hooks.Stop`を追加します。`hooks.Stop`がすでにある場合は、その配列に以下のハンドラーを追加します。

```json
{
  "hooks": {
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "/bin/bash \"/absolute/path/to/voice-hook/scripts/claude-stop-voice.sh\"",
            "timeout": 10
          }
        ]
      }
    ]
  }
}
```

設定例のファイル：[configs/claude.json](configs/claude.json)

### Antigravity

`~/.gemini/config/hooks.json`の最上位に、以下の`voice-notification`を追加します。同じ名前の項目がすでにある場合は、その通知設定を更新します。

```json
{
  "voice-notification": {
    "Stop": [
      {
        "type": "command",
        "command": "/bin/bash \"/absolute/path/to/voice-hook/scripts/antigravity-stop-voice.sh\"",
        "timeout": 10
      }
    ]
  }
}
```

設定例のファイル：[configs/antigravity.json](configs/antigravity.json)

## 音声の確認

このフォルダで以下を実行すると、指定したアプリの音声が1本ランダムに鳴ります。フックの設定前でも確認できます。

```sh
bash scripts/codex-stop-voice.sh --test
bash scripts/claude-stop-voice.sh --test
bash scripts/antigravity-stop-voice.sh --test
```

音が鳴らない場合は、Macの音量・出力先と、設定に記載したスクリプトの絶対パスを確認してください。`--test`で鳴るのにフックから鳴らない場合は、フックの`PATH`から`jq`と`afplay`を実行できるか確認してください。

## 音声を変更する

対応するフォルダの音声を、好みのファイルに置き換えてください。

| アプリ | 音声を置くフォルダ |
| --- | --- |
| Codex | `voices/codex/` |
| Claude Code | `voices/claude/` |
| Antigravity | `voices/antigravity/` |

ファイル名は自由です。対応する拡張子は`.wav`、`.mp3`、`.m4a`、`.aac`、`.flac`、`.aiff`です。フォルダ内の対応音声をすべてランダム再生の候補にするので、1本だけにしたい場合は、その音声だけを残してください。

### Codex用音声のセリフ

1. 「……お願いされた作業、終わったよ。確認してね。」
2. 「……コーデックスの処理、終わった。あとは、よろしく。」
3. 「……作業、終わったから。結果、見といて。」

### Claude Code用音声のセリフ

1. 「お待たせいたしましたわ！お願いされた作業、ばっちり終わりましたの！」
2. 「やりましたわ！クロードの処理が終わりましたの。ご確認くださいませ！」
3. 「作業完了ですわ！ふふっ、結果をご覧になってくださいませ！」

## ファイル構成

```text
voice-hook/
├── configs/          # 各アプリに追加する設定例
│   ├── codex.toml
│   ├── claude.json
│   └── antigravity.json
├── scripts/
│   ├── codex-stop-voice.sh
│   ├── claude-stop-voice.sh
│   └── antigravity-stop-voice.sh
├── voices/
│   ├── codex/        # Codex用音声：3本
│   ├── claude/       # Claude Code用音声：3本
│   └── antigravity/  # Antigravity用音声：3本
├── previews/        # GitHubのREADMEに添付する試聴用MP4：各アプリ1本
├── docs/
│   └── github-audio-preview.md  # 公開時にプレイヤーを埋め込む手順
└── README.md
```
