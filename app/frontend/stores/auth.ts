import { defineStore } from 'pinia';
import { ref } from 'vue';

export interface UserInfo {
  identity: string
  provider: string
}

export interface PKCEParams {
  redirect_uri: string
  client_id: string
  response_code: string
  code_challenge: string
  code_challenge_method: string
  scope: string[]
  state: string
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

  const getPKCEParams = async (provider: string) => {
    let url = `http://localhost:3000/pkce/${provider}`
    const response = await fetch(url, {
      method: 'GET',
    })
    const responseData = await response.json();
    if (!response.ok) {
      const error = new Error(
        responseData.message || 'Failed to authenticate. Check your login data.'
      );
      throw error;
    }
    return responseData
  }

  return { jwt, expiry, identity, provider, isAuthenticated, getUserInfo, getPKCEParams }
})
