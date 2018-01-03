<!-- Script for Review -->
<script>
errors = {
  review: false,
  food_rating: false,
  clean: false,
  safety: false,
  facility: false,
  locality: false
}

  var reviewHandle = document.getElementById('review_review');
  var foodHandle = document.getElementById('food');
  var cleanHandle = document.getElementById('clean');
  var safetyHandle = document.getElementById('safety');
  var facilityHandle = document.getElementById('facility');
  var localityHandle = document.getElementById('locality');

  var submitHandle = document.getElementById('value')

  var formHandle = document.getElementById('new_review') 

  var foodInput = foodHandle.getElementsByTagName('input')  
  var cleanInput = cleanHandle.getElementsByTagName('input');
  var facilityInput = facilityHandle.getElementsByTagName('input');
  var localityInput = localityHandle.getElementsByTagName('input');
  var safetyInput = safetyHandle.getElementsByTagName('input');
  
  var reviewMsgHandle = document.getElementById('reviewError');
  var cleanMsgHandle = document.getElementById('cleanError');
  var safetyMsgHandle = document.getElementById('safetyError');
  var facilityMsgHandle = document.getElementById('facilityError');
  var foodMsgHandle = document.getElementById('foodError');
  var localityMsgHandle = document.getElementById('localityError');

  reviewHandle.addEventListener('keyup',function(){
    if(reviewHandle.value.length <150 ){
      console.log(reviewHandle.value.length);
      submitHandle.disabled = true;    
      }
 },false) 

function validatereview(){
      if(reviewHandle.value == ""){
        reviewMsgHandle.innerHTML = "Can't Be blank";
        errors.review = false;     
      }else if(reviewHandle.value.length < 150) {
        reviewMsgHandle.innerHTML = "Review should contain minimum 150 Characters";
        errors.review = false;
      }else{
        reviewMsgHandle.innerHTML = "";
        errors.review  = true;
      }
}

function validatefood(){   
  var selected = 0;
    for(var i = 0;i < foodInput.length;i++){
      if(foodInput[i].checked){
        selected = foodInput[i].value;
      }
    }
    if(selected == 0){
      foodMsgHandle.innerHTML = "cont be blank";
      errors.food_rating = false
    }else{
      foodMsgHandle.innerHTML = "";
      errors.food_rating = true;
    }

}

function validateclean(){   
  var selected = 0;
    for(var i = 0;i < cleanInput.length;i++){
      if(cleanInput[i].checked){
        selected = cleanInput[i].value;
      }
    }
    if(selected == 0){
      cleanMsgHandle.innerHTML = "cont be blank";
       errors.clean = false
    }else{
    cleanMsgHandle.innerHTML = "";
       errors.clean = true;
    }
}

function validatelocality(){   
  var selected = 0;
    for(var i = 0;i < localityInput.length;i++){
      if(localityInput[i].checked){
        selected = localityInput[i].value;
      }
    }
    if(selected == 0){
      localityMsgHandle.innerHTML = "cont be blank";
       errors.locality = false
    }else{
      localityMsgHandle.innerHTML = "";
       errors.locality = true;
    }
}


function validatefacility(){   
  var selected = 0;
    for(var i = 0;i < facilityInput.length;i++){
      if(facilityInput[i].checked){
        selected = facilityInput[i].value;
      }
    }
    if(selected == 0){
      facilityMsgHandle.innerHTML = "cont be blank";
       errors.facility = false
    }else{
    facilityMsgHandle.innerHTML = "";
       errors.facility = true;
    }
}


function validatesafety(){   
  var selected = 0;
    for(var i = 0;i < safetyInput.length;i++){
      if(safetyInput[i].checked){
        selected = safetyInput[i].value;
      }
    }
    if(selected == 0){
      safetyMsgHandle.innerHTML = "cont be blank";
       errors.locality = false
    }else{
      safetyMsgHandle.innerHTML = "";
       errors.locality = true;
    }
}

formHandle.addEventListener('submit',function(e){
  //validatefood();
  //validatereview();
  //validatelocality();
  //validatefacility();
  //validatesafety();
  //validateclean();

   // if(Object.values(errors).includes(false)){
    // e.preventDefault();
  }
},false)
</script>
<%# if user_signed_in? %>
                  <%# if can? :update, review %>
                      <%#= link_to 'Edit', edit_review_path(review) %>
                  <%# end %>
                  <%# if can? :destroy, review %>
                      <%#= link_to 'Destroy', review, method: :delete, data: { confirm: 'Are you sure?'}%>
                  <%# end %>
              <%# end %>


              <center>
  <div class = "col-md-12">
      <div class="page-header">
          <h2>Location</h2>
      </div>
          <iframe width="700" height="500" frameborder="0" style="border:0" src="https://www.google.com/maps/embed/v1/place?key=AIzaSyBipgxMczyujD8knh17CWPulk7h2shwOF8&q=<%= @room.name %>,<%= @room.address %>"></iframe>
      </div>
  </div>