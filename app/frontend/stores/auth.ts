import { defineStore } from 'pinia';
import { ref } from 'vue';
import { useCookies } from '@vueuse/integrations/useCookies'
import { useToken } from '../composables/useToken'

export interface UserInfo {
  identifier: string
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

const cookies = useCookies()
const { getJWT, saveJWT, removeJWT } = useToken();

export const useAuthStore = defineStore('auth', () => {
  const expiry = ref<Date|null>(null)
  const identifier = ref<string|null>(null)
  const provider = ref<string|null>(null)

  const isAuthenticated = (): boolean => {
    return identifier.value !== null
      && provider.value !== null
      && getJWT() !== null
    //let now: number = new Date().getTime()
    //return jwt.value !== null && expiry.value !== null && (now < expiry.value.getTime())
    //return true
  }

  const getUserInfo = (): UserInfo => {
    return { identifier: identifier.value, provider: provider.value }
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

  const updateUserInfo = () => {
    const userInfo = cookies.get('user_info')
    if (userInfo === null || userInfo === undefined) return;
    console.log(cookies.get('user_info'))
    identifier.value = userInfo['identifier']
    provider.value = userInfo['provider']
    saveJWT(userInfo['jwt'])
  }

  const logout = () => {
    cookies.remove('user_info')
    identifier.value = null
    provider.value = null
    removeJWT()
  }

  return {
    expiry,
    identifier,
    provider,
    isAuthenticated,
    getUserInfo,
    getPKCEParams,
    updateUserInfo,
    logout,
  }
});
