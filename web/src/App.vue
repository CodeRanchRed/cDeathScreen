<template>
  <div class="death-root" v-if="visible">
    <div class="death-canvas" ref="canvas">
      <img :src="bgSvg" class="layer-bg" alt="" />

      <img :src="effectSvg" class="layer-effect" alt="" />

      <div class="you-are-text">{{ locale.you_are }}</div>

      <div class="dead-wrap">
        <div class="dead-text">{{ locale.dead }}</div>
      </div>

      <div class="main-panel">
        <img :src="mainSvg" class="main-svg" alt="" />

        <div
          class="avatar-wrap"
          :style="{
            WebkitMaskImage: `url(${avatarMask})`,
            maskImage: `url(${avatarMask})`,
          }"
        >
          <img :src="playerAvatar" class="avatar-img" alt="avatar" />
        </div>

        <div class="label-location">{{ location }}</div>
        <div class="label-killer">{{ killerName }}</div>
        <div class="label-death-type">{{ deathType }}</div>

        <div class="timer-row">
          <template v-for="i in totalSegs" :key="i">
            <img
              :src="i <= filledCount ? filledSvg : unfilledSvg"
              class="timer-seg"
              alt=""
            />
          </template>
        </div>

        <div class="info-btn" @click="toggleInfo">{{ locale.info_btn }}</div>
      </div>

      <transition name="info-anim">
        <div v-if="infoOpen" class="info-group">
          <img :src="lineSvg" class="line-svg" alt="" />
          <div class="info-box">
            <img :src="infoSvg" class="info-svg" alt="" />
            <p class="info-kill-text">
              {{ locale.killed_by_prefix }}
              <span class="orange">{{ killerName }}</span>
              {{ locale.killed_by_mid }}
              <span class="orange">{{ deathType }}</span>
              {{ locale.killed_by_suffix }}
            </p>
            <p class="info-time">{{ locale.time_label }}</p>
            <p class="info-dist">{{ locale.distance_label }}</p>
            <div class="info-time-val">{{ timeOfDeath }}</div>
            <div class="info-dist-val">{{ distance }}</div>
          </div>
        </div>
      </transition>
    </div>
  </div>
</template>

<script>
import bgSvg from "./assets/bg.svg";
import effectSvg from "./assets/effect.svg";
import mainSvg from "./assets/main.svg";
import filledSvg from "./assets/filled.svg";
import unfilledSvg from "./assets/unfilled.svg";
import infoSvg from "./assets/info.svg";
import lineSvg from "./assets/line.svg";
import avatarMask from "./assets/avatar-mask.png";

const DESIGN_W = 2457;
const DESIGN_H = 1345;

const DEFAULT_LOCALE = {
  you_are: "YOU ARE",
  dead: "Dead!",
  info_btn: "[J] Info",
  killed_by_prefix: "You were killed by",
  killed_by_mid: "with a",
  killed_by_suffix: "weapon",
  time_label: "Time",
  distance_label: "Distance",
};

const nuiPost = (name, data = {}) => {
  fetch(`https://${GetParentResourceName()}/${name}`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(data),
  }).catch(() => {});
};

export default {
  name: "DeathScreen",

  data() {
    return {
      bgSvg,
      effectSvg,
      mainSvg,
      filledSvg,
      unfilledSvg,
      infoSvg,
      lineSvg,
      avatarMask,

      visible: false,

      playerAvatar: "https://i.pravatar.cc/128?img=8",
      killerName: "Code Ranch",
      deathType: "Melee",
      location: "Annesburg",
      timeOfDeath: "1:37 AM",
      distance: "5m",

      totalSegs: 54,
      filledCount: 54,
      timerInterval: null,
      timerDuration: 30000,

      infoOpen: false,

      locale: { ...DEFAULT_LOCALE },
    };
  },

  mounted() {
    this.applyScale();
    window.addEventListener("resize", this.applyScale);
    window.addEventListener("message", this.onNuiMessage);
  },

  beforeUnmount() {
    window.removeEventListener("resize", this.applyScale);
    window.removeEventListener("message", this.onNuiMessage);
    clearInterval(this.timerInterval);
  },

  methods: {
    applyScale() {
      const canvas = this.$refs.canvas;
      if (!canvas) return;
      const scaleX = window.innerWidth / DESIGN_W;
      const scaleY = window.innerHeight / DESIGN_H;
      const scale = Math.max(scaleX, scaleY);
      const offsetX = (window.innerWidth - DESIGN_W * scale) / 2;
      const offsetY = (window.innerHeight - DESIGN_H * scale) / 2;
      canvas.style.transform = `translate(${offsetX}px, ${offsetY}px) scale(${scale})`;
    },

    onNuiMessage(event) {
      const data = event.data;
      if (!data || !data.type) return;

      if (data.type === "showDeath") {
        this.killerName = data.killerName || DEFAULT_LOCALE.unknown;
        this.deathType = data.deathType || DEFAULT_LOCALE.unknown;
        this.location = data.location || "";
        this.timeOfDeath = data.time || "—";
        this.distance = data.distance || "—";
        this.playerAvatar = data.avatar || "https://i.pravatar.cc/128?img=8";

        this.locale = { ...DEFAULT_LOCALE, ...(data.locale || {}) };

        this.infoOpen = false;
        this.visible = true;
        this.$nextTick(() => this.applyScale());
        this.startTimer();
        return;
      }

      if (data.type === "hideDeath") {
        this.visible = false;
        this.infoOpen = false;
        clearInterval(this.timerInterval);
        return;
      }

      if (data.type === "setInfoPanel") {
        this.infoOpen = !!data.open;
        return;
      }
    },

    startTimer() {
      clearInterval(this.timerInterval);
      this.filledCount = this.totalSegs;
      const stepMs = this.timerDuration / this.totalSegs;

      this.timerInterval = setInterval(() => {
        if (this.filledCount > 0) {
          this.filledCount--;
          if (this.filledCount === 0) {
            clearInterval(this.timerInterval);
            nuiPost("deathscreen:timerExpired");
          }
        }
      }, stepMs);
    },

    toggleInfo() {
      this.infoOpen = !this.infoOpen;
    },
  },
};
</script>

<style scoped>
@import url("https://fonts.googleapis.com/css2?family=Comforter+Brush&family=Newsreader:ital,opsz,wght@0,6..72,200..800;1,6..72,200..800&display=swap");

*,
*::before,
*::after {
  box-sizing: border-box;
  margin: 0;
  padding: 0;
}

.death-root {
  position: fixed;
  inset: 0;
  width: 100vw;
  height: 100vh;
  overflow: hidden;
  background: transparent;
}

.death-canvas {
  position: absolute;
  top: 0;
  left: 0;
  width: 2457px;
  height: 1345px;
  transform-origin: top left;
}

.layer-bg {
  position: absolute;
  inset: 0;
  width: 2457px;
  height: 1345px;
  object-fit: cover;
  z-index: 0;
}

.layer-effect {
  position: absolute;
  top: 36.2%;
  left: 50%;
  width: 500px;
  height: 500px;
  transform: translate(-50%, -50%);
  object-fit: contain;
  z-index: 1;
  pointer-events: none;
  animation: glowPulse 3s ease-in-out infinite;
}

@keyframes glowPulse {
  0%,
  100% {
    opacity: 0.9;
    transform: translate(-50%, -50%) scale(1);
  }
  50% {
    opacity: 1;
    transform: translate(-50%, -50%) scale(1.05);
  }
}

.you-are-text {
  position: absolute;
  top: 35%;
  left: 50%;
  transform: translate(-50%, -50%);
  color: #fff;
  font-family: "Newsreader", serif;
  font-size: 112px;
  font-weight: 500;
  line-height: 1;
  letter-spacing: -1.8px;
  white-space: nowrap;
  z-index: 5;
  text-align: center;
  animation: fadeTitle 0.8s cubic-bezier(0.22, 1, 0.36, 1) both;
}

.dead-wrap {
  position: absolute;
  top: 39.5%;
  left: 49%;
  width: 280px;
  height: 120px;
  display: flex;
  align-items: center;
  justify-content: center;
  transform: translate(-16%, -50%);
  z-index: 5;
}

.dead-text {
  font-family: "Comforter Brush", cursive;
  font-size: 118px;
  font-weight: 400;
  color: #ec9641;
  line-height: 1;
  letter-spacing: -1.8px;
  white-space: nowrap;
  text-shadow: 0 4px 4px rgba(0, 0, 0, 0.25);
  -webkit-text-stroke: 1px #000;
  transform: rotate(18deg);
  animation: fadeDead 1s cubic-bezier(0.22, 1, 0.36, 1) 0.1s both;
}

.main-panel {
  position: absolute;
  top: 1010px;
  left: 970px;
  width: 610px;
  height: 228px;
  z-index: 10;
  animation: slideUp 0.5s cubic-bezier(0.22, 1, 0.36, 1) 0.2s both;
}

.main-svg {
  position: absolute;
  inset: 0;
  width: 100%;
  height: 100%;
  object-fit: fill;
}

.avatar-wrap {
  position: absolute;
  top: 18.5px;
  left: 455px;
  width: 120px;
  height: 120px;
  z-index: 2;
  overflow: hidden;
  -webkit-mask-size: 100% 100%;
  -webkit-mask-repeat: no-repeat;
  -webkit-mask-position: center;
  mask-size: 100% 100%;
  mask-repeat: no-repeat;
  mask-position: center;
}

.avatar-img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
}

.label-location {
  position: absolute;
  top: 38px;
  left: 315px;
  width: 135px;
  font-family: "Newsreader", serif;
  font-size: 18px;
  font-weight: 600;
  color: #2c2929;
  line-height: 22px;
  white-space: nowrap;
  text-align: left;
  z-index: 2;
}

.label-killer {
  position: absolute;
  top: 101px;
  left: 98px;
  width: 155px;
  font-family: "Newsreader", serif;
  font-size: 15px;
  font-weight: 600;
  color: #2c2929;
  line-height: 22px;
  white-space: nowrap;
  z-index: 2;
}

.label-death-type {
  position: absolute;
  top: 100.5px;
  left: 271px;
  width: 130px;
  font-family: "Newsreader", serif;
  font-size: 15px;
  font-weight: 600;
  color: #2c2929;
  line-height: 22px;
  white-space: nowrap;
  z-index: 2;
}

.timer-row {
  position: absolute;
  top: 162px;
  left: 42px;
  display: flex;
  align-items: center;
  gap: 1.2px;
  z-index: 2;
}

.timer-seg {
  width: 6px;
  height: 42px;
  object-fit: fill;
  flex-shrink: 0;
}

.info-btn {
  position: absolute;
  top: 171px;
  left: 492px;
  width: auto;
  height: auto;
  background: transparent;
  border: none;
  border-radius: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  font-family: "Newsreader", serif;
  font-size: 19px;
  font-weight: 600;
  color: #2c2929;
  white-space: nowrap;
  cursor: pointer;
  user-select: none;
  z-index: 4;
  transition: opacity 0.15s;
}

.info-btn:hover {
  opacity: 0.8;
}

.info-group {
  position: absolute;
  top: 1010px;
  left: 1852px;
  width: 610px;
  height: 228px;
  z-index: 20;
}

.line-svg {
  position: absolute;
  top: 104px;
  left: -294px;
  width: 170px;
  height: 14px;
  object-fit: fill;
  z-index: 25;
  pointer-events: none;
}

.info-box {
  position: absolute;
  top: 0;
  left: -288px;
  width: 610px;
  height: 228px;
}

.info-svg {
  position: absolute;
  inset: 0;
  width: 100%;
  height: 100%;
  object-fit: fill;
}

.info-kill-text {
  position: absolute;
  top: 20px;
  left: 180px;
  width: 260px;
  font-family: "Newsreader", serif;
  font-size: 17px;
  font-weight: 500;
  color: #e0d4d4;
  line-height: 27px;
  z-index: 2;
}

.info-time {
  position: absolute;
  top: 128px;
  left: 225px;
  font-family: "Newsreader", serif;
  font-size: 20px;
  font-weight: 600;
  color: #2c2929;
  line-height: 24px;
  white-space: nowrap;
  z-index: 2;
}

.info-time-val {
  position: absolute;
  top: 128px;
  left: 350px;
  font-family: "Newsreader", serif;
  font-size: 18px;
  font-weight: 600;
  color: #2c2929;
  line-height: 24px;
  white-space: nowrap;
  z-index: 2;
}

.info-dist {
  position: absolute;
  top: 177px;
  left: 230px;
  font-family: "Newsreader", serif;
  font-size: 20px;
  font-weight: 600;
  color: #2c2929;
  line-height: 24px;
  white-space: nowrap;
  z-index: 2;
}

.info-dist-val {
  position: absolute;
  top: 177px;
  left: 390px;
  font-family: "Newsreader", serif;
  font-size: 20px;
  font-weight: 600;
  color: #2c2929;
  line-height: 24px;
  white-space: nowrap;
  z-index: 2;
}

.orange {
  color: #ec9641;
}

.info-anim-enter-active {
  animation: infoIn 0.22s cubic-bezier(0.22, 1, 0.36, 1) both;
}

.info-anim-leave-active {
  animation: infoOut 0.15s ease both;
}

@keyframes infoIn {
  from {
    opacity: 0;
    transform: translateX(-10px);
  }
  to {
    opacity: 1;
    transform: translateX(0);
  }
}

@keyframes infoOut {
  from {
    opacity: 1;
    transform: translateX(0);
  }
  to {
    opacity: 0;
    transform: translateX(-6px);
  }
}

@keyframes fadeTitle {
  from {
    opacity: 0;
    transform: translate(-50%, calc(-50% - 16px));
  }
  to {
    opacity: 1;
    transform: translate(-50%, -50%);
  }
}

@keyframes fadeDead {
  from {
    opacity: 0;
    transform: rotate(18deg) translateY(8px);
  }
  to {
    opacity: 1;
    transform: rotate(18deg) translateY(0);
  }
}

@keyframes slideUp {
  from {
    opacity: 0;
    transform: translateY(12px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}
</style>
