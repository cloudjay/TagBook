    <!-- Delete button popup -->
    <script type="text/javascript">
    function confirm_delete(title, isbn) {
        	if (confirm("Delete '"+title+"'?"))
        	    		window.location = "/delete.jsp?isbn="+isbn;
            }
    </script>

    <!-- Tweet button API -->
    <script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0];if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src="https://platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(document,"script","twitter-wjs");</script>