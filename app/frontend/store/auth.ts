import { defineStore } from 'pinia';
import { ref } from 'vue';

export interface UserInfo {
  identity: string
  provider: string
}

export const useAuthStore = defineStore('auth', () => {
  const jwt = ref<string|null>(null)
  const expiry = ref<Date|null>(null)
  const identity = ref<string|null>('someone')
  const provider = ref<string|null>('twitter')

  const isAuthenticated = (): boolean => {
    let now: number = new Date().getTime()
    return jwt.value !== null && expiry.value !== null && (now < expiry.value.getTime())
    //return true
  }

  const getUserInfo = (): UserInfo => {
    return { identity: identity.value, provider: provider.value }
  }

  return { jwt, expiry, identity, provider, isAuthenticated, getUserInfo }
})
