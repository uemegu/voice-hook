# GitHubのREADMEに試聴プレイヤーを表示する

READMEの各サンプル欄には、プレイヤーを埋め込む位置をHTMLコメントで用意しています。公開時に試聴用MP4をGitHubへ添付し、そこで発行されたURLを入れると、README内で再生できます。

リポジトリへWAVやMP4を追加するだけでは、README内の再生コントロールは表示されません。相対パスの`<audio controls>`ではなく、GitHubが生成する`https://github.com/user-attachments/assets/…`の添付URLを使用します。[GitHub上での動作例](https://github.com/orgs/community/discussions/53410)、[GitHubの添付ファイル仕様](https://docs.github.com/en/get-started/writing-on-github/working-with-advanced-formatting/attaching-files)も参照してください。

## 添付するファイル

| READMEのサンプル欄 | 添付するファイル |
| --- | --- |
| Codex | [codex-stop-voice-01.mp4](../previews/codex-stop-voice-01.mp4) |
| Claude Code | [claude-stop-voice-01.mp4](../previews/claude-stop-voice-01.mp4) |
| Antigravity | [antigravity-stop-voice-01.mp4](../previews/antigravity-stop-voice-01.mp4) |

各ファイルは、同名のWAVの音声をAACとしてMP4に収めたものです。通知フックは`voices/`のWAVを再生します。

## 公開時の手順

1. 公開先の[uemegu/voice-hook](https://github.com/uemegu/voice-hook)で`README.md`を編集します。
2. 編集欄で`CODEX_AUDIO_PLAYER`のHTMLコメントを削除し、その位置へ`previews/codex-stop-voice-01.mp4`をドラッグ＆ドロップします。
3. アップロード後に挿入される添付URLを、そのまま独立した行に置きます。コードブロックや通常のリンク記法で囲む必要はありません。
4. Claude CodeとAntigravityも、それぞれのコメント位置へ対応するMP4を添付します。
5. GitHubのPreviewで、3つのプレイヤーと音声を確認してから変更を保存します。ミュートされている場合は、プレイヤーの音量ボタンで解除してください。
6. GitHub側で保存したREADMEを、手元のフォルダにも反映します。

添付URLはGitHubへのアップロード後に発行されるため、公開前のローカルファイルだけでは確定できません。READMEには架空のURLを入れず、コメントで埋め込み位置を示しています。
