## 🥚 포카기: 포켓몬 타입 상성 기반 알까기 게임

https://926kaul.github.io/Pokagi/

포카기(Pokagi)는 포켓몬스터 1세대(151종)와 독특한 **물리 엔진 및 타입 상성 시스템**을 결합한 특별한 알까기(물리 충돌) 게임입니다. 포켓몬의 스탯이 충돌 물리량에 직접 영향을 미치며, 전략적인 배치와 타입 상성 계산이 승리의 열쇠입니다.

---

### 🎮 게임 시스템 및 특징

#### 1. 타입 상성과 충돌 속도 (Velocity)

포켓몬이 서로 충돌한 후의 **속도(Velocity)**는 **타입 상성(Type Effectiveness)**에 의해 결정됩니다. 충돌하는 두 포켓몬의 타입 1과 타입 2가 모두 계산에 반영됩니다 (1세대 타입 상성표 기준).

* **계산 예시:** 바위/땅 타입 포켓몬이 바위/비행 타입 포켓몬을 공격할 경우:
    > $1.0 (\text{바위} \to \text{바위}) \times 0.5 (\text{바위} \to \text{땅}) \times 2.0 (\text{땅} \to \text{바위}) \times 0 (\text{땅} \to \text{비행}) = 0$
    > (최종 결과가 0이므로 해당 충돌은 무효화됩니다.)

#### 2. 포켓몬의 물리 속성 결정

각 포켓몬의 물리적 특성(크기, 질량, 속도)은 **종족값**을 기준으로 50, 70, 100, 120을 경계로 **1~5등급**으로 분류되어 결정됩니다.

| 물리 속성 | 결정 기준 |
| :---: | :---: |
| **크기 (Size)** | HP 등급 |
| **운동 질량 (Moving Mass)** | $\text{max}(\text{공격}, \text{특수})$ 등급 |
| **정지 질량 (Static Mass)** | $\text{max}(\text{방어}, \text{특수})$ 등급 |
| **최대 속도 (Max Speed)** | 스피드 등급 |

#### 3. 성장 및 도감 수집

* **도감 등록 및 사용:** 쓰러뜨린 **적 포켓몬**은 도감에 등록되어 이후 플레이 시 아군으로 사용할 수 있게 됩니다.
* **진화:** 전투에서 살아남은 **아군 포켓몬**은 승리 시 진화할 수 있습니다. (단, 이브이 계열은 진화 불가)

#### 4. 히든 스테이지 (Hidden Stage)

전투에서 아군 포켓몬 3마리 **모두 생존**한 상태로 승리하면 **히든 스테이지**가 잠금 해제됩니다.

* **히든 스테이지 위치:** 5-2, 8-2, 9-2, 그리고 Real-Final 스테이지가 존재합니다.

#### 5. 턴 순서 개념 및 게임 속도 조정

* **턴 순서:** 각 **세대**에 모든 포켓몬은 한 번씩 움직일 기회인 "턴"을 갖게 됩니다. 한 세대에서 **턴 순서는 스피드와 무관**하며, 세대가 시작할 때 **중심에서 먼 포켓몬**부터 턴을 부여받게 됩니다.
* **게임 속도 조정:** Gen 6 이후부터의 빠른 게임 진행을 위해 마찰력이 감소됩니다. 마찰 계수가 0.95 $\to$ **0.98**가 됩니다.

#### 6. 스테이지 유형

* **정규 스테이지 (Stage X):** 체육관 관장으로, 포켓몬 배치와 구성이 **고정**되어 있습니다.
* **랜덤 스테이지 (Stage X-1):** 야생 포켓몬이 **일정 범위 내에서 랜덤하게** 출현하며, 중복 방지 보정이 적용되어 다회차 플레이를 돕습니다.
* **히든 스테이지 (Stage X-2):** 이전 정규 스테이지에서 아군 포켓몬 3마리가 모두 생존하면, 특별한 포켓몬을 잡을 수 있는 히든 스테이지로 진입할 수도 있습니다.

#### 7. 151종 수집

진화, 히든 스테이지, 야생 포켓몬 사냥을 통해 **다회차 플레이**를 하면서 151종의 모든 포켓몬을 수집할 수 있습니다.

---

### 🐛 버그 제보 및 문의

버그나 문제점은 아래 채널로 제보해 주시면 감사하겠습니다.

* GitHub Issue
* 이메일: 926kaul@gmail.com
* 소스코드: https://github.com/926kaul/Pokagi_Gamemaker

***

# 🇬🇧 English Version: Pokagi Readme

## 🥚 Pokagi: Type Effectiveness Physics Simulator

Pokagi is a unique physics-based collision (marbles/egg-smashing) game that combines the Pokémon Generation 1 (151 species) roster with a distinctive **physics engine and Type Effectiveness system**. A Pokémon's stats directly influence its collision properties, making strategic placement and type analysis key to victory.

---

### 🎮 Game System and Features

#### 1. Velocity After Collisions Linked to Type Effectiveness

The **Velocity** of Pokémon after a collision is determined by **Type Effectiveness**. Crucially, both Type 1 and Type 2 of the two colliding Pokémon are fully reflected in this calculation (based on the Gen 1 Type Chart).

* **Calculation Example:** If a Rock/Ground type attacks a Rock/Flying type:
    > $1.0 (\text{Rock} \to \text{Rock}) \times 0.5 (\text{Rock} \to \text{Ground}) \times 2.0 (\text{Ground} \to \text{Rock}) \times 0 (\text{Ground} \to \text{Flying}) = 0$
    > (Since the final result is 0, the collision is nullified.)

#### 2. Determining Pokémon's Physical Attributes

A Pokémon's physical attributes (Size, Mass, Speed) are classified into **1 to 5 tiers** based on their **Base Stats**, cut off at values of 50, 70, 100, and 120.

| Physical Attribute | Determination Base |
| :---: | :---: |
| **Size** | HP Tier |
| **Moving Mass** | $\text{max}(\text{Attack}, \text{Special})$ Tier |
| **Static Mass** | $\text{max}(\text{Defense}, \text{Special})$ Tier |
| **Max Speed** | Speed Tier |

#### 3. Growth and Pokedex Collection

* **Pokedex and Usage:** Defeated **enemy Pokémon** are registered in the Pokedex and become available for use as allies in subsequent runs.
* **Evolution:** Surviving **allied Pokémon** may evolve upon winning a battle. (Eevee and its evolutions cannot evolve.)

#### 4. Hidden Stages

A **Hidden Stage** may be unlocked if you win a regular stage with **all three allied Pokémon surviving**.

* **Hidden Stage Locations:** Hidden stages 5-2, 8-2, 9-2, and the Real-Final stage exist.

#### 5. Turn Order Concept and Game Speed Adjustment

* **Turn Order:** In each **Generation**, every Pokémon gets one turn to move. The **turn order is independent of the Speed stat** and is assigned at the start of a Generation, prioritizing the Pokémon **farthest from the center**.
* **Game Speed Adjustment:** For faster gameplay (similar to Gen 6 onwards), friction has been reduced. The friction coefficient has changed from 0.95 $\to$ **0.98**.

#### 6. Stage Types

* **Regular Stages:** Feature Gym Leaders with **fixed** Pokémon composition and placement.
* **Random Stages (-1, -2):** Feature wild Pokémon that appear **randomly** within a certain range (with a bias to prevent duplicates), encouraging multiple playthroughs.

#### 7. Collecting All 151 Species

Through evolution, hidden stages, and catching wild Pokémon, you can collect all 151 species across **multiple playthroughs**.

---

### 🐛 Bug Reporting and Inquiry

Please report any bugs or issues via the channels below:

* GitHub Issue
* Email: 926kaul@gmail.com
* Source Code: https://github.com/926kaul/Pokagi_Gamemaker
