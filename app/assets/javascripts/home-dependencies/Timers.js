// Set the date we're counting down to
var UniqueDate = new Date("July 25, 2018 23:37:25").getTime();
var ArenaDate = new Date("July 25, 2018 21:37:25").getTime();
var CTFDate = new Date("July 25, 2018 22:37:25").getTime();
var FWDate = new Date("July 26, 2018 20:37:25").getTime();

// Update the count down every 1 second
var x = setInterval(function() {

  // Get todays date and time
  var now = new Date().getTime();

  // Find the distance between now an the count down date
  var unique_distance = UniqueDate - now;
  var arena_distance =  ArenaDate - now;
  var ctf_distance =  CTFDate - now;
  var fw_distance =  FWDate - now;
    
  // unique
  var u_hours = Math.floor((unique_distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
  var u_minutes = Math.floor((unique_distance % (1000 * 60 * 60)) / (1000 * 60));
  var u_seconds = Math.floor((unique_distance % (1000 * 60)) / 1000);
    

  // Arena
  var a_hours = Math.floor((arena_distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
  var a_minutes = Math.floor((arena_distance % (1000 * 60 * 60)) / (1000 * 60));
  var a_seconds = Math.floor((arena_distance % (1000 * 60)) / 1000);
    
    
  // CTF
  var c_hours = Math.floor((ctf_distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
  var c_minutes = Math.floor((ctf_distance % (1000 * 60 * 60)) / (1000 * 60));
  var c_seconds = Math.floor((ctf_distance % (1000 * 60)) / 1000);
    
    
  // FW
  var days = Math.floor(fw_distance / (1000 * 60 * 60 * 24));
  var hours = Math.floor((fw_distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
  var minutes = Math.floor((fw_distance % (1000 * 60 * 60)) / (1000 * 60));
  var seconds = Math.floor((fw_distance % (1000 * 60)) / 1000);

  // Display the result in the element with id
  document.getElementById("unique").innerHTML = u_hours + "h "
  + u_minutes + "m " + u_seconds + "s ";
    
  document.getElementById("arena").innerHTML = a_hours + "h "
  + a_minutes + "m " + a_seconds + "s ";
//    
  document.getElementById("ctf").innerHTML = c_hours + "h "
  + c_minutes + "m " + c_seconds + "s ";
//    
  document.getElementById("fw").innerHTML = days + "D " + hours + "h "
  + minutes + "m " + seconds + "s ";

  // If the count down is finished, write some text 
  if (unique_distance < 0) {
    clearInterval(x);
    document.getElementById("unique").innerHTML = "Unique Has Appeared";
  }
   if (arena_distance < 0) {
    clearInterval(x);
    document.getElementById("arena").innerHTML = "Arena is now open";
  }
      if (ctf_distance < 0) {
    clearInterval(x);
    document.getElementById("ctf").innerHTML = "CTF is now open";
  }
      if (fw_distance < 0) {
    clearInterval(x);
    document.getElementById("fw").innerHTML = "Fortress War has begun";
  }
}, 1000);