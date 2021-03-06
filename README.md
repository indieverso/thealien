<p align="center">
  <a href="http://www.sumelms.com">
    <img src=".github/logo.svg" height="80"/>
  </a>
</p>

<p align="center">
  <a href="https://discord.gg/FqXEuYZ" target="_blank">
    <img alt="Discord" src="https://img.shields.io/discord/768176989953327135">
  </a>
  <a aria-label="Versão do Godot" href="https://godotengine.org/">
    <img src="https://img.shields.io/badge/godot-3.2-informational?logo=godot-engine"></img>
  </a>
  <img alt="GitHub release (latest SemVer)" src="https://img.shields.io/github/v/release/indieverso/thealien">
</p>

## About the game

The Alien is an open-source multiplayer game, inspired by "Among Us" and "Mafia".

In this game, you are placed with other players on some map, and you need to use your social and investigative skills to survive.

This game doesn't have any commercial goal, it is developed just for fun, and with the help of the community.

## How to play (WIP)

1. You can download the game directly from [itch.io](https://rluders.itch.io/the-alien). It is 100% free.
2. Play! 😎

## How to develop (WIP)

This repository has 4 Godot projects:

- **Game**, this is the game as you may guess.
- **Server**, this is the game server.
- **Auth**, this is the authentication server.
- **Gateway**, this is the gateway server that connects the player with the authentication server.

In order to execute the game to test, you should open all the projects on Godot, and execute them in the following order:

1. Auth
2. Gateway
3. Sever
4. Game

The credentials to login to the game is both (username and password): **test**

# Contributing

Thank you for considering contributing to the project. I'll strongly advise you to choose an open issue to work on it, and then submit a PR.

# License

The project code is licensed under MIT. All the game art assets (images, audio files) are under [CC BY-NC 4.0](https://creativecommons.org/licenses/by-nc/4.0/).

For more information check the [LICENSE](LICENSE) file.
