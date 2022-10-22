<template>
  <p>User Data Form</p>
</template>
<script>
export default {
  name: 'UserDataForm',
  data() {
    return {
        name: '',
        email: '',
        foodPreferences: [
          'vegetarian',
          'gluten'
        ],

      }
  }
}
</script>