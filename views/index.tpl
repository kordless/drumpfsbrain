<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <title>Lucidworks Labs :: Semantic Image Search</title>
  <link rel="stylesheet" href="/css/chosen.css">
  <link rel="stylesheet" href="/css/style.css">

  <!-- Latest compiled and minified CSS -->
  <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css" integrity="sha384-PmY9l28YgO4JwMKbTvgaS7XNZJ30MK9FAZjjzXtlqyZCqBY6X6bXIkM++IkyinN+" crossorigin="anonymous">

  <!-- Optional theme -->
  <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap-theme.min.css" integrity="sha384-jzngWsPS6op3fgRCDTESqrEJwRKck+CILhJVO5VvaAZCq8JYf8HsR/HPpBOOPZfR" crossorigin="anonymous">

</head>
<body>
  <div id="container">
    <div id="content">
      <header>
        <h1>Semantic Search Term Demo</h1>
      </header>
      <p>This demo uses discussions on <a href="https://cooking.stackexchange.com/">StackExchange Seasoned Advice</a> to optimize results coming in from a Google's Image query. This may useful for conducting unassisted training with neural networks on imagery for a given topic.</p>
      <p>Start by entering/selecting a "cooking" or "baking" related topic from the dropdown. As you select topics, new topics will be added.</p>

      <div class="side-by-side clearfix">
        <div>
          <select id="topics" data-placeholder="a baking topic" multiple class="chosen-select" tabindex="8">
          </select>
        </div>
      </div>

      <div class="side-by-side clearfix">
        <div id="images">
        </div>
      </div>

    </div>
  </div>
  
  <script src="/js/jquery-3.2.1.min.js" type="text/javascript"></script>
  <script src="/js/chosen.jquery.js" type="text/javascript"></script>
  <script src="/js/prism.js" type="text/javascript" charset="utf-8"></script>
  <script src="/js/init.js" type="text/javascript" charset="utf-8"></script>
  <script src="https://stackpath.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js" integrity="sha384-vhJnz1OVIdLktyixHY4Uk3OHEwdQqPppqYR8+5mjsauETgLOcEynD9oPHhhz18Nw" crossorigin="anonymous"></script>

  <script type="text/javascript">
    $().ready(function() {
      // stop words
      var stopwords = [];
      $.getJSON("/stopwords", function(data) {
        $.each(data, function(index, value) {
          stopwords.push(value);
        });
      });
      console.log(stopwords);

      // initialize with a default topic
      topic = "cook bake eat";
      $.getJSON( "/skg/"+topic, function(data) {
        console.log(stopwords);
        console.log("total documents: "+data.facets.count);
        // initilize
        $.each(data.facets.stack_exchange.related.buckets, function(index, value) {
          // $('#results').append(value.val+":"+value.relatedness.relatedness+"<br/>");
          if ($.inArray(value.val, stopwords) != -1) {
            console.log("stopword found " + value.val);
          } else {
            $('#topics').append("<option id='"+value.val+"' value='"+value.val+"'>"+value.val+"</option>");
          }
        });
        $("#topics").trigger("chosen:updated");

        $.getJSON( "/img/"+topic, function(data) {
          $.each(data.items, function(index, value) {
            $('#images').prepend(`<a target=_blank href="`+value.image.contextLink+`"><img onerror="this.style.display='none';" src="`+value.link+`" width=256>`)
          });
        });
      });

      // update topics as user searches
      $('#topics').chosen().change(function() {
        // Change No Result Match text to Searching.
        topics = "";
        $.each($('li span'), function(index, value) {
          topics = topics + " " + $(this).text(); 
        })
        console.log("using: "+topics);
        $.getJSON( "/skg/"+topics, function(data) {
            $.each(data.facets.stack_exchange.related.buckets, function(index, value) {
              var valval = value.val.replace("'", "");
              console.log(valval);

              // $('#results').append(value.val+":"+value.relatedness.relatedness+"<br/>");
              if ( $('#topics option#'+valval).val() == undefined ) {
                if ($.inArray(valval, stopwords) != -1) {
                  console.log("stopword " + valval);
                } else {
                  console.log("adding "+valval);
                  $('#topics').prepend("<option id='"+valval+"' value='"+valval+"'>"+valval+"</option>");
                }
              } else {
                console.log("topic exists: " + valval);
              }
          });
          $("#topics").trigger("chosen:updated");

          $('#images').html("");
          $.getJSON( "/img/"+topics, function(data) {
            $.each(data.items, function(index, value) {
              $('#images').prepend(`<a target=_blank href="`+value.image.contextLink+`"><img onerror="this.style.display='none';" src="`+value.link+`" width=256>`)
            });
          });
        });
      });

      $('.chosen-search-input').keyup(function(e){
        if(e.keyCode == 13) {
          // console.log($(".chosen-search-input").val());
        }
      });

    });
  </script>
</body>
</html>
