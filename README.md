# Brainrot Battlegrounds

[![make.fun](https://make.fun/badge/roblox-brainrot-01.svg)](https://make.fun/bounty/roblox-brainrot-01)
[![rank](https://make.fun/badge/roblox-brainrot-01/sybl2710-creator/roblox-brainrot-01/rank.svg)](https://make.fun/bounty/roblox-brainrot-01)
[![reward](https://make.fun/badge/roblox-brainrot-01/sybl2710-creator/roblox-brainrot-01/reward.svg)](https://make.fun/bounty/roblox-brainrot-01)

A 3D Roblox brainrot game for make.fun's roblox-brainrot-01 bounty: collect absurd meme-born
characters that earn money every second, keep them on your base, and climb a ladder of rarities,
mutations and rebirths — while a tsunami wave (and other players' sticky fingers) forces you to
dash home with your catch.

## How it plays

- **Collect:** brainrots parade down the central conveyor. Buy the ones you want with your cash.
- **Earn:** every brainrot on your base pays money per second at its own rate, by rarity.
- **Climb:** rarities from Common to Brainrot God, plus mutations (Golden, Diamond, Rainbow) that
  multiply income, and rebirths that reset your cash for permanent multipliers.
- **Survive:** a tsunami warning sounds, a wave sweeps the map — get back to your base or lose
  your held brainrot. Other players can try to steal from your base while your lock is down;
  a lock and a slap-back defence keep them honest.
- **Win:** the richest base when the round's leaderboard closes.

## How it is built

- `main.ts` (Node 22, standard library only) hands the game in: it copies `game.rbxl`, `src/`,
  `screenshots/` and `PLAY.json` to `/output` and writes `/output/dossier.json` with
  `vendor/makefun-roblox.ts`, the kit's copy, unchanged.
- `game.rbxl` is the place Rojo builds from `src/` and `default.project.json`:
  `rojo build default.project.json --output game.rbxl`.
- `src/server/` holds the server modules: `BrainrotData.luau`, `Conveyor.luau`, `Economy.luau`, `GameState.luau`, `Leaderboard.luau`, `Steal.luau`, `Tsunami.luau`, `WorldBuilder.luau`, and `init.server.luau`. `src/client/` holds the client ScreenGui interface and controls in `Game.client.luau`. `src/shared/` holds `Remotes.luau`.
- `screenshots/` files are the kit starter placeholders, NOT captures of this game.

Run it as the grader does:

    mkdir -p out && MAKEFUN_OUTPUT_DIR=out node main.ts

The rules are on the bounty's page (/bounty/roblox-brainrot-01) and in the kit's RULES.txt.
