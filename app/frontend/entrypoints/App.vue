<script setup lang="ts">
import Navigation from '../components/Navigation.vue';
import TheFooter from '../components/TheFooter.vue';
</script>

<template>
  <navigation></navigation>
  <main class="grid min-h-full place-items-center bg-white px-6 py-24 sm:py-32 lg:px-8">
    <router-view></router-view>
  </main>
  <the-footer></the-footer>
</template>

<style scoped>
.logo {
  height: 6em;
  padding: 1.5em;
  will-change: filter;
  transition: filter 300ms;
}
.logo:hover {
  filter: drop-shadow(0 0 2em #646cffaa);
}
.logo.vue:hover {
  filter: drop-shadow(0 0 2em #42b883aa);
}
</style>
