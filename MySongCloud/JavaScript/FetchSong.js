//<script src="https://apis.google.com/js/api.js"></script>


//<script>
  /**
   * Sample JavaScript code for youtube.search.list
   * See instructions for running APIs Explorer code samples locally:
   * https://developers.google.com/explorer-help/code-samples#javascript
   */

//for testing
var helloWorld = "Hello, World!"

//fetch list of youtube urls by keyword
function fetchSongByKeyword(keyword){
    
    return gapi.client.youtube.search.list({
      "part": [
        "snippet"
      ],
      "maxResults": 5,
      "q": keyword
    })
//        .then(function(response) {
//                // Handle the results here (response.result has the parsed body).
//                console.log("Response", response);
//              },
//              function(err) { console.error("Execute error", err); });
}
gapi.load("client:auth2", function() {
  gapi.auth2.init({client_id: "1034619658742-jcjqqct1aedq2ilid9ikfik34flkhpdd.apps.googleusercontent.com"});
});


  function authenticate() {
    return gapi.auth2.getAuthInstance()
        .signIn({scope: "https://www.googleapis.com/auth/youtube.force-ssl"})
        .then(function() { console.log("Sign-in successful"); },
              function(err) { console.error("Error signing in", err); });
  }
  function loadClient() {
    gapi.client.setApiKey("AIzaSyAf9nUASmVJnQ3Pqj_VcPi6TJWQxllTD0A");
    return gapi.client.load("https://www.googleapis.com/discovery/v1/apis/youtube/v3/rest")
        .then(function() { console.log("GAPI client loaded for API"); },
              function(err) { console.error("Error loading GAPI client for API", err); });
  }
  // Make sure the client is loaded and sign-in is complete before calling this method.
  
//</script>
//<button onclick="authenticate().then(loadClient)">authorize and load</button>
//<button onclick="execute()">execute</button>
