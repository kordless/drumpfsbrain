<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <title>Drumpf's Brain</title>

    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css?family=Lato:100,300,400,700,900" rel="stylesheet">

    <!-- Grab Google CDN's jQuery, with a protocol relative URL; fall back to local if offline -->
    <script src="//ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
    <script>window.jQuery || document.write('<script src="/js/jquery.min.js"><\/script>')</script>

    <!-- Latest compiled and minified CSS -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css" integrity="sha384-PmY9l28YgO4JwMKbTvgaS7XNZJ30MK9FAZjjzXtlqyZCqBY6X6bXIkM++IkyinN+" crossorigin="anonymous">

    <!-- Optional theme -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap-theme.min.css" integrity="sha384-jzngWsPS6op3fgRCDTESqrEJwRKck+CILhJVO5VvaAZCq8JYf8HsR/HPpBOOPZfR" crossorigin="anonymous">

    <!-- Latest compiled and minified JavaScript -->
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js" integrity="sha384-vhJnz1OVIdLktyixHY4Uk3OHEwdQqPppqYR8+5mjsauETgLOcEynD9oPHhhz18Nw" crossorigin="anonymous"></script>

  </head>
  <body style="font-family: Arial;border: 0 none;">   
    <div class="row">
      <div class="col-xs-6 col-md-2">
        <div class="input-group">
          <input type="text" class="form-control" placeholder="enter a topic" id="search"/>
        </div>
      </div>
      <div class="col-xs-6 col-md-4">
        <div id="results">
        </div>
      </div>
      <div class="col-xs-6 col-md-4">
        <div id="images">
        </div>
      </div>
    </div>
    <script type="text/javascript">
      $().ready(function() {
        $('#search').bind("enterKey",function(e){
          var topic = $('#search').val();
          $('#results').html("");
          $('#images').html("");
          $.getJSON( "/skg/"+topic, function(data) {
            console.log("total documents: "+data.facets.count);
            var image_search = "";
            $.each(data.facets.stack_exchange.related.buckets, function(index, value) {
              // $('#results').append(value.val+":"+value.relatedness.relatedness+"<br/>");
              $('#results').append(value.val+"<br/>");
              if (index < 3) {
                image_search = image_search + " " + value.val;
              }
              console.log(image_search);
            });
            $.getJSON( "/img/"+topic, function(data) {
              console.log(data);
              $.each(data.items, function(index, value) {
                console.log(value);
                $('#images').append('<img src="'+value.link+'" width=512><br/>')
              });
            });
          });
        });
        $('#search').keyup(function(e){
            if(e.keyCode == 13)
            {
                $(this).trigger("enterKey");
            }
        });
      });
    </script>
  </body>
</html>