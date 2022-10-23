<template>
  <section>
    <div v-if="ingredients.length > 0">
      <h2>Your Ingredients</h2>
      <p style="text-align: center;" @click="$emit('ingredients-cleared')">clear ingrediants</p>
    </div>
    <div v-else>
      <h2>HUNGRY?</h2>
      <p style="text-align: center;">Tell me what you have!</p>
    </div>
    <ul v-if="ingredients.length > 0" class="selected-ingredients-list">
      <!-- <li v-for="{name, image, id} in ingredients" :key="id">
        <img :src="imgBaseUrl + image" :alt="name" :title="name"/>
        <p>{{ name }}</p>
        <div><svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"><path d="m16.192 6.344-4.243 4.242-4.242-4.242-1.414 1.414L10.535 12l-4.242 4.242 1.414 1.414 4.242-4.242 4.243 4.242 1.414-1.414L13.364 12l4.242-4.242z"/></svg></div>
      </li> -->
      <Ingredient-list-item v-for="ingredient in ingredients" :key="ingredient.id" :ingredient="ingredient">
        <template #svgIcon>
          <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" @click="$emit('remove-ingredient', $event, ingredient)"><path d="m16.192 6.344-4.243 4.242-4.242-4.242-1.414 1.414L10.535 12l-4.242 4.242 1.414 1.414 4.242-4.242 4.243 4.242 1.414-1.414L13.364 12l4.242-4.242z"/></svg>
        </template>
      </Ingredient-list-item>
    </ul>
  </section>
</template>

<script>
  export default {
    name: "SelectedIngredients",
    props: {
        ingredients: {
            type: Array,
            default() {
                return [];
            }
        },
    },
    // methods: {
    //   removeIngredient: function(event, ingredient){
    //     console.log(event);
    //     console.log(ingredient);
    //   }
    // }
}
</script>

<style scoped>
  ul {
    padding: 0;
  }
  h3 {
    font-size: 24px;
    text-align: center;
    margin: 12px 0 0.7em 0;
    color: #b9b9b9;
  }
  div > p {
    text-align: center;
    line-height: 1.5em;
    color: #b9b9b9;
  }
</style>