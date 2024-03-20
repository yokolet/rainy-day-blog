<script setup lang="ts">
import { useAuthStore } from '../store/auth';

const store = useAuthStore()
console.log(store.jwt, store.expiry, store.isAuthenticated())

const greeting = `Hi ${ store.getUserInfo().identity} at ${ store.getUserInfo().provider}!`
</script>

<template>
  <div class="navbar bg-zinc-100">
    <div class="navbar-start">
      <a class="btn btn-ghost text-xl text-fuchsia-800">Home</a>
    </div>
    <div class="navbar-center">
      <div
          v-if="store.isAuthenticated()"
          class="text-base text-fuchsia-900 font-bold sm:text-sm md:text-md lg:text-lg">
        {{ greeting }}
      </div>
    </div>
    <div class="navbar-end">
      <a v-if="!store.isAuthenticated()" class="btn btn-xs sm:btn-sm btn-primary">LOG IN or SIGN UP</a>
      <a v-if="store.isAuthenticated()" class="btn btn-xs sm:btn-sm btn-neutral">LOG OUT</a>
    </div>
  </div>
</template>

<style scoped>

</style>
