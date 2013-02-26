<li class="location_item" onclick="window.location.href = '/locations/{{=it.id}}'">
  <img class="location_marker" src="{{=it.icon}}" />
  <p class="location_content">
    <a class="location_link" href="/locations/{{=it.id}}">{{=it.description}}</a><br>
    Category: <span class="location_category">{{=it.category}}</span>
    <span class="location_tips">
      {{=it.tips_count}} 
      {{if(it.tips_count == 1) { }} tip {{ } else { }} tips {{ } }}
    </span>
  </p>
</li>
