//Pre-selected DOM objects
const dogPic = document.querySelector('#dog-pic');
const btn = document.querySelector('#fetch-btn');
const select = document.querySelector('#breeds');

//Google Maps nearby dog parks by keyword url
const dogParkMap = "https://www.google.com/maps/search/?api=1&query=";

//Dog API endpoint
const dogApi = "https://api.thedogapi.com/v1/images/search";

//Add your own API key, get one here: https://thedogapi.com/
// const apiKey = "live_woLAIfjkwQGv11v4T42Wx5Z9llJOse9ryYTIit1c3FtDm2wZHaJvEmcrIzbETdiz";
const apiKey = "live_Ml2HAyax74IG5SUCmNnD8cgr97PcL3gLAuZsZuAZJIoxCJdsIZMCTlfHXVZbcyeO";

/***************** Practice Session APIs ********************/
//Breeds list API
const breedsApi = "https://api.thedogapi.com/v1/breeds";

//Dogs by breed API
const dogByBreedApi = "https://api.thedogapi.com/v1/images/search?breed_ids=";
/***************** End Practice Session APIs ********************/

const params = {
  method: "GET",
  headers: {
    "x-api-key": apiKey
  }
};

// Exercise 1: Simple GET request
// Show nearby dog parks with GET request from Google URL
// 1. Select the anchor tag with id dog-parks and assign it a variable.
const dogPark = document.querySelector('#dog-park');
// 2. Set the href property of the anchor tag to the DogParkMap URL, plus your neighborhood, and the keywords: "dog parks" 
dogPark.href = `${dogParkMap}Seattle dog parks`;
// 3. Test the hyperlink, do parks around your area show up?

// Exercise 2: Use fetch() to get a response from the dog API
// 1. Create an async function called fetchDog.
// 2. Inside fetchDog, add a try...catch block.
// 3. Inside try, create a variable called response with the value await fetch(), pass fetch the dogApi. Log response in the console.
// 4. Inside catch, console any error.
// 5. Call the function. 
async function fetchDog() {
    try {
        let response = await fetch(dogApi, params);
        console.log(response);
        // Exercise 3: Exploring status codes
        // 1. Inside try, log response.status in the console. 
        console.log(response.status);
        return response.json();
    }
    catch(error) {
        console.log("Something went wrong:", error);
    }
}
// fetchDog();

// Exercise 4: Convert the API response to JSON
// 1. Inside fetchDog(), inside try: return response.json(); Make sure to use the await operator
// 2. Outside the function, remove the previous function call
// 3. Create a variable with the function call as value, and log it in the console
// let getDog = fetchDog();
// console.log(getDog);


// Exercise 5: Showing the dog on the page
// 1. Create another async function called showDog.
// 2. Inside showDog, create a variable called dog with value await fetchDog().
// 3. Log dog in the console.
// 4. Set the src value of dogPic to the url. 
// 5. Call the showDog function. 
// Activating the fetch button
// 6. Add a click event listener to the fetch button to call showDog 
async function showDog() {
    let dog = await fetchDog();
    console.log(dog);
    dogPic.src = dog[0].url;
}
btn.addEventListener("click", showDog);
showDog();

// Exercise 6: Authentication and params
// The dog API requires some security in order to access dogs by breeds, which will be part of the Practice Session.
// 1. Navigate to: https://thedogapi.com/ 
// Click Get Your API key, select the free account and follow the prompts
// 2. Copy and paste your API key as the value for the provided variable
// 3. Create an object called params with 2 keys: method, headers
// Set the value of method to GET
// Set the value of headers to an object as shown. Paste the apiKey variable as the value of x-api-key
// 4. Inside fetchDog(), inside try:
// Add params as the second argument to fetch