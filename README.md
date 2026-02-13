# Super Mario Gyarax (Godot 4.2+)

最小構成の三人称3Dアクションサンプルです。固定重力 (`Vector3.DOWN`) の通常ステージで以下を実装しています。

## 実装内容
- M0
  - プレイヤー: WASD移動（カメラ基準）、`Space`ジャンプ、`Shift`ダッシュ
  - 接地判定 + 斜面対応（`CharacterBody3D` の floor 設定）
  - 三人称カメラ: マウスYaw/Pitch、レイキャストで壁めり込み防止
- M1
  - チェックポイント (`Area3D`) に触れると復帰地点更新
  - 落下（`kill_height`）でリスポーン
  - ゴール (`Area3D`) に入るとクリア表示
- M2
  - 鍵を3つ拾うと扉が開放
  - 動く床（往復移動）
- デバッグUI
  - 速度、接地状態、鍵数、現在リスポーン地点

## シーン構成
- `scenes/GameRoot.tscn`
- `scenes/Level01.tscn`
- `scenes/Player.tscn`
- `scenes/CameraRig.tscn`
- `scenes/UI.tscn`

## スクリプト構成
- `scripts/PlayerController.gd`
- `scripts/CameraRig.gd`
- `scripts/Checkpoint.gd`
- `scripts/Goal.gd`
- `scripts/CollectibleKey.gd`
- `scripts/Door.gd`
- `scripts/MovingPlatform.gd`
- `scripts/LevelManager.gd`

## 起動手順
1. Godot 4.2 以降でこのフォルダを Import。
2. `project.godot` を開く。
3. `F5` 実行（メインシーンは `GameRoot`）。

## 操作
- 移動: `WASD`
- ジャンプ: `Space`
- ダッシュ: `Shift`
- カメラ: マウス移動
- マウス解除: `Esc`
- マウス再キャプチャ: クリック
