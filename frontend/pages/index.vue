<template>
  <div>
    <main-header>
      <a href="/profile">Profile</a>
    </main-header>
    <main>
    <selected-ingredients :ingredients="selectedIngredients" @remove-ingredient="removeIngredient"></selected-ingredients>
    <article>
      <h2>Add Ingredients</h2>
      <label>
        <input id="ingredientSearch" v-model.lazy="ingredientSearchTerm" type="text" name="ingredientSearch" :class="ingredientData.length > 0 ? 'autosuggest-active' : ''">
        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"><path d="M10 18a7.952 7.952 0 0 0 4.897-1.688l4.396 4.396 1.414-1.414-4.396-4.396A7.952 7.952 0 0 0 18 10c0-4.411-3.589-8-8-8s-8 3.589-8 8 3.589 8 8 8zm0-14c3.309 0 6 2.691 6 6s-2.691 6-6 6-6-2.691-6-6 2.691-6 6-6z"/></svg>
      </label>
      <ul v-if="ingredientData" class="autosuggest-ingredients">
        <!-- <li v-for="ingredient in ingredientData" :key="ingredient.id" @click="selectIngredient(ingredient)">
          <h3>{{ ingredient.name }}</h3>
          <img :src="ingredientImgUrl + ingredient.image" :alt="ingredient.name" :title="ingredient.name"/>
          <br>
        </li> -->
        <Ingredient-list-item v-for="ingredient in ingredientData" :key="ingredient.id" :ingredient="ingredient" @click.native="selectIngredient(ingredient)">
          <template #svgIcon>
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"><path d="M19 11h-6V5h-2v6H5v2h6v6h2v-6h6z"/></svg>
          </template>
        </Ingredient-list-item>
      </ul>
      <button class="find-recipe" @click="fetchRecipes(recipeSearchIngredients)">Search Recipes</button>
    </article>
    <article>
      <h2>Recipes</h2>
      <!-- <input id="recipeSearch" v-model.lazy="recipeSearchTerm" type="text" name="recipeSearch">
      <button @click="fetchRecipes(recipeSearchTerm)">Fetch Recipe from Input</button> -->
      <ul v-if="recipeData">
        <li v-for="{title, image, id} in recipeData" :key="id">
          <a :href="`/recipes/${id}`">
            <h3>{{ title }}</h3>
            <img :src="image" :alt="title" :title="id"/>
          </a>
        </li>
      </ul>
    </article>    
  </main>
  </div>
</template>

<script>
export default {
  name: 'Home',
  data() {
    return {
      apiKey: this.$config.publicApiKey,
      ingredientSearchTerm: '',
      recipeSearchTerm: 'apple,vinegar,tomato',
      ingredientData: [],
      recipeData: null,
      selectedIngredients: [],
      ingredientImgUrl: 'https://spoonacular.com/cdn/ingredients_250x250/'
    }
  },
  computed: {
    recipeSearchIngredients() {
      const ingredientArray = this.selectedIngredients.map( ingredient => ingredient.name );
      return ingredientArray.join(',');
    }
  },
  watch: {
    ingredientSearchTerm(newVal) {
      this.fetchIngredient(newVal);
    }
  },
  mounted() {
    this.fetchAws();
  },
  methods: {
    fetchAws() {
      // fetch('https://ok4mjcl5pdk47rbbpfh43f5wme0tigur.lambda-url.us-east-1.on.aws/', {
      fetch('https://nd4wdoqnsbdfdrmbtn7feda5si0phmun.lambda-url.eu-central-1.on.aws/', {
        method: 'POST',
        test: 'this is a test string'
      })
      .then( response => response.json())
      .then ( data => {
        console.log(data);
      })
      .catch( error => {
        console.error(error);
      })
    },
    fetchIngredient(query) {
      const baseUrl = 'https://api.spoonacular.com/food/ingredients/search';
      
      fetch(`${baseUrl}?apiKey=${this.apiKey}&query=${query}`)
      .then( res => res.json() )
      .then( data => {
        this.ingredientData = data.results;
      });
    },
    removeIngredient: function(event, ingredient){
      this.selectedIngredients = this.selectedIngredients.filter(entry => entry.id !== ingredient.id);
    },
    fetchRecipes(ingredientList) {
      // if ( !query || query.length < 2 ) return;
      // const baseUrl = 'https://api.spoonacular.com/recipes/complexSearch';
  
      // fetch(`${baseUrl}?apiKey=${this.apiKey}&includeIngredients=${ingredientList}`)
      // apples,+flour,+sugar
      fetch(`https://api.spoonacular.com/recipes/findByIngredients?apiKey=${this.apiKey}&ingredients=${ingredientList}`)
      .then( res => res.json() )
      .then( data => {
        console.log(data.results);
        this.recipeData = data.results;
      });
    },
    selectIngredient(ingredientObject) {
      this.selectedIngredients.push(ingredientObject);
      this.ingredientSearchTerm = '';
    }
  },
}
</script>
<style scoped>
main {
  padding: 12px;
}
h2 {
    font-size: 24px;
    text-align: center;
    margin-bottom: .7em;
    margin-top: 24px;
  }
  label {
    position: relative;
  }
  label svg {
    position: absolute;
    right: 8px;
    top: 3px;
    width: 20px;
    height: 20px;
  }
  input {
    width: 100%;
    border: 1px solid #999;
    border-radius: 12px;
    padding: 8px 12px;
  }
  input.autosuggest-active {
    border-radius: 12px 12px 0 0;
    /* border-bottom-width: 0; */
  }
  ul.autosuggest-ingredients {
    border: 1px solid #999;
    border-radius: 0 0 12px 12px;
    max-height: 400px;
    overflow-y: auto;
    border-top-width: 0;
  }
  ul.autosuggest-ingredients li {
    padding: 12px;
    cursor: pointer;
  }
  button.find-recipe {
    font-size: 16px;
    text-transform: uppercase;
    letter-spacing: .5px;
    color: #fff;
    background: #DE162C;
    border: none;
    padding: 16px 32px;
    margin: 12px 0;
  }
</style>