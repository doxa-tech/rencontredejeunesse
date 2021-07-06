$(document).on("DOMContentLoaded", function() {
  
  if($(".nested-form").length ) {

    var $addFields = $(".add-fields");
    var $fieldsFor = $(".fields-for");
    var limit = parseInt($addFields.attr("data-limit"));
    var numberOfFields = 1;

    updateAddButton($addFields, numberOfFields, limit);
   
    $addFields.click(function(e) {
      e.preventDefault();
      var count = $(this).attr("data-count"), type = $(this).data("type"),
          lastFields = $("." + type + "-fields:last"), newFields = lastFields.clone();
      count++;
      newFields.find("input, select")
        .attr("name", function(i, val) { if(val) { return val.replace(/\d/, count) } })
        .attr("id", function(i, val) { if(val) { return val.replace(/\d/, count) } })
        .val([]);
      newFields.find("label").attr("for", function( i, val ) { return val.replace(/\d/, count) });
      newFields.insertAfter(lastFields);
      $(this).attr("data-count", count);
      newFields.show();
      numberOfFields++;
      updateAddButton($addFields, numberOfFields, limit);
    });

    $fieldsFor.on("click", ".remove-fields", function(e) {
      e.preventDefault();
      var type = $(this).attr("data-type"),
          fields = $(this).parents("." + type + "-fields");
      fields.find("input[identifier=destroy]").val("1");
      fields.hide();
      numberOfFields--;
      updateAddButton($addFields, numberOfFields, limit);
    });

  }

});

function updateAddButton($button, number, limit) {
  if(!isNaN(limit)) {
    if(number == limit) {
      $button.hide();
    } else if(number < limit) {
      $button.show();
    }
  }
}
