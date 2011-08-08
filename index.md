---
layout: default
title: home
---

{% for post in site.posts %}
[{{ post.date | date: "%B %d, %Y" }} - {{ post.title }}]({{ post.url }})
{% endfor %}