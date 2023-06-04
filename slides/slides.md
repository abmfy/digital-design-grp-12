---
theme: seriph
background: /dino.webp
css: unocss
---

<style>
h2 {
    margin-bottom: 0.5rem !important;
}
</style>

# 数设项目展示：Chrome 小恐龙

游宇凡 @ouuan · 王博文 @abmfy · 2023.6.6

---
layout: center
---

# 项目成果

-   基本完整复刻了原版 Chrome 小恐龙的所有元素
-   画面分辨率 1280×800 @ 60Hz（实际画面大小 1280×300）
-   支持按键输入和传感器输入两种输入方式
-   传感器输入：通过绑在大腿上的传感器检测玩家跳跃和下蹲的动作（~~可以用来健身~~）
-   使用传感器时游戏难度较高，提供多条生命作为补偿

---
layout: statement
---

<style scoped>
.statement {
    background-position: center;
    background-size: cover;
    background-image: linear-gradient(#000a, #000c), url('/dino.webp')
}
</style>

# 请观看现场演示

---

# 整体设计简述

<span/>

<v-click>

整体设计分为三大部分：传感器、游戏逻辑、画面输出。<span class="text-xs">（具体模块划分见实验报告）</span>

游宇凡负责传感器和画面输出两部分，王博文负责游戏逻辑。

我们之间的接口非常简单，只有蹲下、起跳的信号，画面上每个元素的坐标信息，控制昼夜转换的信号，以及画面刷新信号、时钟信号等，大大降低了沟通成本。

</v-click>

<v-click>

传感器通过无线模块连接到实验板，采用 UART 协议。

</v-click>

<v-click>

画面输出采用双显存 + ring buffer，元素绘制基于原版游戏使用的 sprite 图（略有修改），压缩至只有 8 种颜色并裁剪掉不需要的部分从而能放进片内 RAM 而不损失分辨率。

</v-click>

---

# 整体设计简述

<span/>

游戏逻辑 TODO

---

# 踩坑选讲

<v-clicks>

-   外设的供电：纽扣电池电流不足改成充电宝供电（难点在于发现问题出在电流不足）
-   外设的连接：焊接排针 → 透明胶绑定 → 焊接所有连线
-   传感器跳跃检测：各种花里胡哨的检测方法都不如最简陋的方法，但是游戏难度依然很高，需要提供多条生命作为补偿
-   VGA & 显存的时序

</v-clicks>
