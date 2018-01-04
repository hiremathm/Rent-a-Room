<%= form_for @book do |f|%>
    
    <label>Start Date</label><br/>
    <%= f.date_select :start_date, class: "form-control" %><br/>

    <label>End Date</label><br/>
    <%= f.date_select :end_date%><br/>

    <%= f.hidden_field :room_id, value: @booking.room.id %>

    <%= f.submit "Book", class: "btn btn-primary" %>
  <%end%>



  <% if user_signed_in?  %>
      
      <% if current_user.id == @room.user.id %>

        <h4> Add Special Prices</h4>
            <%= form_for @special_price do |f| %>
                <%= f.hidden_field :room_id, value: @room.id %>
                <p class = "form-group">
                  <strong>Start Date :</strong><%= f.text_field :start_date ,class: "form-control"%>
                  <span id = "startError"></span>
                </p>
                <p class = "form-group">
                  <strong>End Date :</strong><%= f.text_field :end_date,class: "form-control" %>
                  <span id = "endError"></span>
                </p>
                <p class = "form-group">
                  <strong>Price :</strong> <%= f.number_field :price,class: "form-control" %>
                  <span id = "priceError"></span>
                </p>
                <%= f.submit "ADD SPECIAL PRICE", class: "btn btn-primary"%>
            <% end %>
        <% end %>
    <% end %>

# form for booking
  var formData = document.getElementById('new_booking');
  var startdateHandle = document.getElementById('booking_start_date');
  var enddateHandle = document.getElementById('booking_end_date');

  var startdateErrorMsg = document.getElementById('startdateError');
  var enddateErrorMsg = document.getElementById('enddateError');

  errors = {
    start: false,
    end: false
  }

  function validatestart()
  {
      if(startdateHandle.value == ""){
        startdateErrorMsg.innerHTML = "Start Date Can't be blank";
        errors.start = false;
      }else{
        startdateErrorMsg.innerHTML = "";
        errors.start = true
      }
  }
  function validateend(){
      if(enddateHandle.value == ""){
        enddateErrorMsg.innerHTML = "End Date Can't be blank";
        errors.end = false;
      }else if(enddateHandle.value < startdateHandle.value){
        enddateErrorMsg.innerHTML = "End Date connot be less than Start Date";
        errors.end = false;
      }else{
        enddateErrorMsg.innerHTML = "";
        errors.end = true;
      }
  }
  formData.addEventListener('submit',function(e)
  {
    validatestart();
    validateend();
    if(Object.values(errors).includes(false)){
      e.preventDefault();
    }
  },false)
  
<!-- Script for Special Price -->

  var startdate = document.getElementById('special_price_start_date');
  var enddate = document.getElementById('special_price_end_date');
  var pricevalue = document.getElementById('special_price_price');

  var startdateMsg = document.getElementById('startError');
  var enddateMsg = document.getElementById('endError');
  var priceErrorMsg = document.getElementById('priceError');

  startdate.addEventListener('blur',function(){
    if(startdate.value == ""){
      startdateMsg.innerHTML = "Start Date Can't be blank";
    }else{
      startdateMsg.innerHTML = "";
    }
  },false);

  enddate.addEventListener('blur',function(){
    if(enddate.value == ""){
      enddateMsg.innerHTML = "End Date Can't be blank";
    }else if(enddate.value < startdate.value){
      enddateMsg.innerHTML = "End Date connot be less than Start Date";
    }else{
      enddateMsg.innerHTML = "";
    }
  },false);

  pricevalue.addEventListener('blur',function(){
    if(pricevalue.value == ""){
      priceErrorMsg.innerHTML = "Please Enter Price";
    }else{
      priceErrorMsg.innerHTML = "";
    }
  },false);
