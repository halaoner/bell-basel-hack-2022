<template>
  <div>
    <main-header>
      <img src="/Profile-Icon.svg" />
    </main-header>
    <div v-if="status.loading">
    <p style="text-align:center">analyzing image</p>
  </div>
  <div v-else-if="status.active">
    <p style="text-align:center">{{ status.message }}</p>
    </div>
    <bell-logo v-else></bell-logo>
    <main>
      <image-scanner v-if="scannerActive" @image-scanned="addScannedImage" @scanner-closed="closeScanner()" @scan-started="displayLoadingMessage()"></image-scanner>
      <selected-ingredients :ingredients="selectedIngredients" @remove-ingredient="removeIngredient" @ingredients-cleared="clearIngredients()"></selected-ingredients>
      <article class="ingredient-input">
      <label>
        <input id="ingredientSearch" v-model.lazy="ingredientSearchTerm" type="text" name="ingredientSearch" :class="ingredientData.length > 0 ? 'autosuggest-active' : ''">
        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"><path d="M10 18a7.952 7.952 0 0 0 4.897-1.688l4.396 4.396 1.414-1.414-4.396-4.396A7.952 7.952 0 0 0 18 10c0-4.411-3.589-8-8-8s-8 3.589-8 8 3.589 8 8 8zm0-14c3.309 0 6 2.691 6 6s-2.691 6-6 6-6-2.691-6-6 2.691-6 6-6z"/></svg>
      </label>
      <ul v-show="ingredientData.length > 0" class="autosuggest-ingredients">
        <Ingredient-list-item v-for="ingredient in ingredientData" :key="ingredient.id" :ingredient="ingredient" @click.native="selectIngredient(ingredient)">
          <template #svgIcon>
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"><path d="M19 11h-6V5h-2v6H5v2h6v6h2v-6h6z"/></svg>
          </template>
        </Ingredient-list-item>
      </ul>
    </article>
    <div id="open-scanner">
      <img src="/Camera-Icon.svg" @click="openScanner()"/>
    </div>
    <article v-show="selectedIngredients.length > 0" class="recipe-output">
      <h2>Recipes</h2>
      <button class="find-recipe" @click="fetchRecipes(recipeSearchIngredients)">Search Recipes</button>
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
      scannerActive: false,
      apiKey: this.$config.publicApiKey,
      ingredientSearchTerm: '',
      recipeSearchTerm: 'apple,vinegar,tomato',
      ingredientData: [],
      recipeData: null,
      selectedIngredients: [],
      ingredientImgUrl: 'https://spoonacular.com/cdn/ingredients_250x250/',
      status: {
        loading: false,
        active: false,
        message: ''
      }
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
  methods: {
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
        console.log(data);
        this.recipeData = data;
      });
    },
    selectIngredient(ingredientObject) {
      if ( this.selectedIngredients.find(ingredient => ingredient.id === ingredientObject.id ) ) {
        this.ingredientSearchTerm = '';
        console.log('That ingredient is already selected');
      }
      this.selectedIngredients.push(ingredientObject);
      this.ingredientSearchTerm = '';
    },
    addScannedImage(tag) {
      console.log(tag);
      const baseUrl = 'https://api.spoonacular.com/food/ingredients/search';
        
      fetch(`${baseUrl}?apiKey=${this.apiKey}&query=${tag}`)
      .then( res => res.json() )
      .then( data => {
        if ( data.results.length > 0 ) {
          const ingredientFromTag = data.results[0];
          this.selectIngredient(ingredientFromTag)
          this.displayStatusMessage(`'${ingredientFromTag.name}' added from image.`)
        } else {
          this.displayStatusMessage(`No ingredient found for ${tag}`);
        }
      });
    },
    closeScanner() {
      this.scannerActive = false;
    },
    openScanner() {
      this.scannerActive = true;
    },
    clearIngredients() {
      this.selectedIngredients = [];
      this.recipeData = [];
    },
    displayStatusMessage(message) {
      this.status.loading = false;
      this.status.active = true;
      this.status.message = message;
      setTimeout( () => {
        this.status.active = false;
      }, 3000);
    },
    displayLoadingMessage() {
      this.status.loading = true;
    }
  },
}
</script>
<style scoped>
main {
  padding: 12px;
}
div#open-scanner {
  text-align: center;
  margin-top: 12px;
}
article.recipe-output {
  text-align: center;
}
  label {
    position: relative;
  }
  label svg {
    position: absolute;
    right: 8px;
    top: 2px;
    width: 20px;
    height: 20px;
  }
  input {
    width: 100%;
    border: 1px solid var(--neutral-11);
    border-radius: 0;
    padding: 16px;
  }
  ul.autosuggest-ingredients {
    padding: 0;
    margin: 0;
    border: 1px solid var(--neutral-11);
    max-height: 400px;
    overflow-y: auto;
    border-top-width: 0;
  }
  ul.autosuggest-ingredients li {
    padding: 12px;
    cursor: pointer;
  }
  .find-recipe {
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