<template>
  <div>
    <header>
      <h1>Home</h1>
      <a href="/profile">Zum Profil</a>
    </header>
    <main>
    <article>
      <h2>Ingredients</h2>
      <input id="ingredientSearch" v-model="ingredientSearchTerm" type="text" name="ingredientSearch">
      <button @click="fetchIngredient()">Fetch Ingredient Data</button>
      <ul v-if="ingredientData">
        <li v-for="{name, image, id} in ingredientData" :key="id">
          <h3>{{ name }}</h3>
          <img :src="ingredientImageBaseUrl + image" :alt="name" :title="name"/>
          <br>
        </li>
      </ul>
    </article>
    <article>
      <h2>Recipes</h2>
      <input id="recipeSearch" v-model="recipeSearchTerm" type="text" name="recipeSearch">
      <button @click="fetchRecipes(recipeSearchTerm)">Fetch Recipe Data</button>
      <ul v-if="recipeData">
        <li v-for="{title, image, id} in recipeData" :key="id">
          <h3>{{ title }}</h3>
          <img :src="image" :alt="title" :title="id"/>
          <br>
        </li>
      </ul>
    </article>

    
  </main>
  </div>
</template>

<script>
// import { useDebounceFn } from '@vueuse/core'
// import { watchThrottled } from '@vueuse/core'

// watchThrottled(
//   this.ingredientSearchTerm,
//   () => { console.log('changed!') },
//   { throttle: 500 },
// );

export default {
  name: 'Home',
  data() {
    return {
      apiKey: this.$config.publicApiKey,
      ingredientSearchTerm: '',
      ingredientImageBaseUrl: 'https://spoonacular.com/cdn/ingredients_250x250/',
      recipeSearchTerm: 'apple,vinegar,tomato',
      ingredientData: null,
      recipeData: null,
    }
  },
  watch: {
    ingredientSearchTerm(newVal, oldVal) {
      console.log(newVal);
    }
  },
  methods: {
    fetchIngredient() {
      // if ( !query || query.length < 2 ) return;
      
      // const baseUrl = 'https://api.spoonacular.com/recipes/complexSearch';
      const baseUrl = 'https://api.spoonacular.com/food/ingredients/search';

      fetch(`${baseUrl}?apiKey=${this.apiKey}&query=${this.ingredientSearchTerm}`)
      .then( res => res.json() )
      .then( data => {
        console.log(data);
        this.ingredientData = data.results;
      });
    },
    fetchRecipes(ingredientList) {
      // if ( !query || query.length < 2 ) return;
      // const baseUrl = 'https://api.spoonacular.com/recipes/complexSearch';
      const baseUrl = 'https://api.spoonacular.com/recipes/complexSearch';
  
      fetch(`${baseUrl}?apiKey=${this.apiKey}&includeIngredients=${ingredientList}`)
      .then( res => res.json() )
      .then( data => {
        console.log(data);
        this.recipeData = data.results;
      });
    }
  },
}
</script>
<style>
header {
  display: flex;
  justify-content: space-between;
  padding: 24px;
  margin-bottom:48px;
  border-bottom: 1px solid #333;
}
main {
  display: flex;
  align-items: flex-start;
  flex-wrap: wrap;
}
main > article {
  padding: 24px;
  width: 50%;
}
main > article:first-child {
  background: #ededed;
}
</style>