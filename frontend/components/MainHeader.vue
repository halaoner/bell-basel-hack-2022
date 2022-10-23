<template>
  <header>
    <h1>Bell Food Assistant</h1>
    <slot></slot>
  </header>
</template>
<style scoped>
  header {
    display: flex;
    justify-content: space-between;
    padding: 24px 12px;
    border-bottom: 1px solid #333;
  }
</style>