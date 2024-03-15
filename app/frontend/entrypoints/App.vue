<script setup lang="ts">
import Navigation from '../components/Navigation.vue';
import TheFooter from '../components/TheFooter.vue';
import Hero from '../components/Hero.vue';
</script>

<template>
  <navigation></navigation>
  <hero></hero>
  <main class="grid min-h-full place-items-center bg-white px-6 py-24 sm:py-32 lg:px-8">
    <router-view></router-view>
  </main>
  <the-footer></the-footer>
</template>

<style>
* {
  box-sizing: border-box;
}

html {
  font-family: sans-serif;
}

body {
  @apply m-0 text-gray-800 bg-white
}
</style>
