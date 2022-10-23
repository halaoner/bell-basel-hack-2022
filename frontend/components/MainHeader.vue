<template>
  <header>
    <h1>Bell Cook Buddy</h1>
    <slot></slot>
  </header>
</template>
<style scoped>
  header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 4px 12px;
    border-bottom: 1px solid var(--neutral-11);
  }
  h1 {
    margin: 0;
    font-size: 18px;
    font-weight: 600px;
  }
</style>