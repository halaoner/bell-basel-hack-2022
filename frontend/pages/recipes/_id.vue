<template>
  <main>
    <article v-if="recipeInfo.title">
      <h3>Basic:</h3>
      <img :src="recipeInfo.image" />
      <h1>{{ recipeInfo.title }}</h1>
      <p v-html="recipeInfo.summary"></p>
      
      <h3>Diets / Intolerances:</h3>
      <p>Vegetarian: {{ recipeInfo.vegetarian ? 'Yes' : 'No' }}</p>
      <p>Vegan: {{ recipeInfo.vegan ? 'Yes' : 'No' }}</p>
      <p>glutenFree: {{ recipeInfo.glutenFree ? 'Yes' : 'No' }}</p>
      <p>dairyFree: {{ recipeInfo.dairyFree ? 'Yes' : 'No' }}</p>
      
      <h3>Cooking:</h3>
      <p><a :href="recipeInfo.sourceUrl">visit original website</a></p>
      <p>servings: {{ recipeInfo.servings }}</p>
      <p>preparing time: {{ recipeInfo.readyInMinutes }}min</p>

      <h3>Ingredients:</h3>
      <ul>
        <li v-for="ingredient in recipeInfo.extendedIngredients" :key="ingredient.id">
          <p>{{ ingredient.nameClean }}</p>
          <p>Amount (us): {{ ingredient.measures.us.amount }} {{ ingredient.measures.us.unitLong }}</p>
          <p>Amount (metric): {{ ingredient.measures.us.amount }} {{ ingredient.measures.us.unitLong }}</p>
        </li>
      </ul>
      
      <h3>Steps:</h3>
      <ol v-for="instructions in recipeInfo.analyzedInstructions" :key="instructions.name">
        <li v-for="step in instructions.steps" :key="step.number">
          <p>{{ step.step }}</p>
        </li>
      </ol>
      <!-- <pre>{{ recipeInfo.analyzedInstructions }}</pre> -->
      
      
      <h3>Special Tags:</h3>
      <p>veryHealthy: {{ recipeInfo.veryHealthy  ? 'Yes' : 'No' }}</p>
      <p>sustainable: {{ recipeInfo.sustainable  ? 'Yes' : 'No' }}</p>
    </article>
    <div v-else-if="recipeLoading">
      <p>recipe loading</p>
    </div>
    <div v-else>
      <p>no recipe found</p>
    </div>
  </main>
</template>

<script>
export default {
  name: 'SingleRecipe',
  data() {
    return {
      currentRecipeId: this.$route.params.id,
      spoonacularKey: this.$config.publicApiKey,
      recipeInfo: {},
      recipeLoading: true
    }
  },
  mounted() {
    this.fetchSingleRecipe();
  },
  methods: {
    fetchSingleRecipe() {
      // fetch(`https://api.spoonacular.com/recipes/informationBulk?apiKey=${this.spoonacularKey}&ids=${this.currentRecipeId}`)
      fetch(`https://api.spoonacular.com/recipes/${this.currentRecipeId}/information?apiKey=${this.spoonacularKey}`)
      .then((res) => res.json())
      .then( data => {
        this.recipeInfo = data;
        this.loading = false;
      })
    },
    // reachForLambda() {
    //   fetch('https://ok4mjcl5pdk47rbbpfh43f5wme0tigur.lambda-url.us-east-1.on.aws', )
    // }
  },
  // async asyncData(params) {
  //   const recipe = await fetch(
  //     `https://api.spoonacular.com/recipes/informationBulk?apiKey=${this.$config.publicApiKey}&ids=${params.slug}`
  //   ).then((res) => res.json())

  //   console.log(recipe);
  // }
}

</script>

<style scoped>
img {
  max-width: 100%;
}
</style>