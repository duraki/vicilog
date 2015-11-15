$(function() {

	var el = $('#release-notes');
	el.html('<h2>Loading…</h2>')

	var success = function(data) {
		//alert(data);
		buildReleases(data);
	}

	var error = function(data) {
		el.html$('<h2>Somethign happened while fetching release notes...</h2><br><pre>Notify us with issue on GitHub.com/dn5/vicilog</pre>')
	}

/*
	$.ajax({
		url: '',
		dataType: 'jsonp',
		success: success,
		error: error
	})
*/

	$.getJSON("changes.json", function(data) {
		buildReleases(data)
	});

});

function buildReleases(data) {
	var releases = $.map(data.releases, createRelease);

  $("#release-notes").empty().append(releases);
}

function createRelease(r) {
	changes = r.description.split('•')
  return $("<div/>")
      .append($("<p class='meta' />")
				.append($("<span class='release-date'/>").text(r.date ? moment(r.date).format('MMMM Do YYYY') : ""))
        .append($("<span class='release-version'/>").text("v" + r.version)))
      .append($("<h2/>").text(r.title))
      .append($("<ul class='changes'/>")
      .append($.map(changes, createChange)));
}

function createChange(changeText) {
	if (changeText != '') {
	  var m = $.trim(changeText).match(/^\[(new|fixed|improved|removed|added)\]\s(.*)/i);
		if (m) {
	    return $("<li/>")
	      .append($("<div class='change-label-container'/>")
	        .append($("<em/>").addClass('change-label change-' + m[1].toLowerCase()).text(m[1])))
	      .append(document.createTextNode(m[2]));
	  }

	  return $("<li/>").text(changeText);
	}
}
