<template>
  <li>
    <img :src="imgBaseUrl + ingredient.image" :alt="ingredient.name" :title="ingredient.name"/>
    <p>{{ ingredient.name }}</p>
    <div><slot name="svgIcon"></slot></div>
  </li>
</template>

<script>
  export default {
    name: 'IngredientListItem',
    props: {
      ingredient: {
        type: Object,
        default() {
          return {
            name: '',
            image: '',
            id: ''
          }
        }
      },
    },
    data() {
      return {
        imgBaseUrl: 'https://spoonacular.com/cdn/ingredients_250x250/'
      }
    }
  }
</script>

<style scoped>
  ul {
    padding: 12px 0;
  }
  li {
    display: grid;
    grid-gap: 0 24px;
    grid-template-columns: max-content 1fr max-content;
    align-items: center;
    padding: 6px 0;
    border-bottom: 1px solid #ececec;
  }
  li img {
    width: 60px;
    height: 60px;
    object-fit: contain;
    mix-blend-mode: multiply;
  }
  li > div {
    padding: 0 8px;
  }
  li > div:hover svg {
    transform: rotate(90deg);
  }
  div > svg {
    width: 32px;
    height: 32px;
    transition: transform .3s ease-in-out;
    cursor: pointer;
  }
</style>