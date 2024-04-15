<script setup lang="ts">
import TheFooter from '../components/TheFooter.vue';
import Hero from '../components/Hero.vue';
import Navigation from '../components/Navigation.vue';
</script>

<template>
  <div class="min-h-screen">
    <navigation></navigation>
    <hero></hero>
    <main class="grid flex-grow bg-white px-6 py-6 sm:py-4 lg:px-8">
      <router-view></router-view>
    </main>
    <the-footer></the-footer>
  </div>
</template>

<style>
* {
  box-sizing: border-box;
}

html {
  font-family: sans-serif;
}

body {
  @apply m-0 text-gray-800 bg-zinc-50
}
</style>
