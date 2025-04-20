<template>
  <div id="app">
    <h1>Fullstack Assessment - Vue + Rails</h1>

    <div v-if="loading">Loading user...</div>

    <div v-else>
      <p><strong>UUID:</strong> {{ uuid }}</p>
      <p><strong>Name:</strong> {{ user?.name }}</p>
      <p><strong>Biography:</strong> {{ user?.biography }}</p>
      <p><strong>ID:</strong> {{ user?.id }}</p>
    </div>

    <div v-if="error" class="error">{{ error }}</div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import api from './api/endpoints'

const uuid = ref('')
const user = ref<any>(null)
const loading = ref(true)
const error = ref<string | null>(null)

// Fetch UUID from /id
const fetchUUID = async () => {
  try {
    const res = await api.id.getId()
    uuid.value = res.id
  } catch {
    error.value = 'Failed to fetch UUID'
  }
}

// Create user with retry
const createUser = async () => {
  let attempt = 0
  const maxAttempts = 3

  while (attempt < maxAttempts) {
    try {
      const res = await api.user.createUser({ name: 'John Doe', biography: 'Auto-created bio' })
      return res.user
    } catch {
      attempt++
      if (attempt === maxAttempts) {
        error.value = 'User creation failed after retries'
        return null
      }
    }
  }
}

const fetchUser = async () => {
  try {
    const res = await api.user.getUser({ id: 1 })  // or whichever ID you want
    user.value = res
  } catch {
    error.value = 'Failed to fetch user'
  } finally {
    loading.value = false
  }
}


// Initialize on mount
onMounted(async () => {
  await fetchUUID()
  await createUser()
  await fetchUser()
})
</script>

<style scoped>
.error {
  color: red;
  font-weight: bold;
}
</style>
