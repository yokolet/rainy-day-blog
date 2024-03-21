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
      <a v-if="!store.isAuthenticated()" class="btn btn-xs sm:btn-sm btn-primary" onclick="login_modal.showModal()">
        <font-awesome-icon icon="fas fa-right-to-bracket" />
        LOG IN
      </a>
      <a v-if="store.isAuthenticated()" class="btn btn-xs sm:btn-sm btn-neutral">
        LOG OUT
        <font-awesome-icon icon="fas fa-right-from-bracket" />
      </a>
    </div>
    <dialog id="login_modal" class="modal sm:modal-middle">
      <div class="modal-box">
        <form method="dialog">
          <button class="btn btn-sm btn-circle btn-ghost absolute right-2 top-2">✕</button>
        </form>
        <h3 class="font-bold text-lg">Continue With:</h3>
        <div class="flex flex-col justify-center">
          <div class="btn text-gray-800 text-center sm:text-sm md:text-md lg:text-lg bg-gray-300 px-4 py-2 mx-5 my-2">
            <font-awesome-icon icon="fab fa-twitter" />
            Twitter
          </div>
          <div class="btn text-gray-800 text-center  sm:text-sm md:text-md lg:text-lg bg-gray-300 px-4 py-2 mx-5 my-2" disabled="disabled">
            <font-awesome-icon icon="fab fa-gitlab" />
            GitLab
          </div>
          <div class="btn text-gray-800 text-center  sm:text-sm md:text-md lg:text-lg bg-gray-300 px-4 py-2 mx-5 my-2" disabled="disabled">
            <font-awesome-icon icon="fab fa-github" />
            GitHub
          </div>
        </div>

      </div>
    </dialog>
  </div>
</template>

<style scoped>

</style>
