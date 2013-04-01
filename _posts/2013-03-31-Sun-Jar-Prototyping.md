---
layout: posts
title: Sun Jar Prototyping
---
![Sun Jar](https://lh3.googleusercontent.com/-H4iETK4HtSY/UVjajKXCLfI/AAAAAAAATFc/GYoIxbpEUX4/s545/solar-sun-jar.jpg)

Sun jars are solar-powered LED night lights. You can find them for sale all over the web and even at some brick-and-mortar retail stores. Making one looked like a fun project, so I started Googling and checking the normal places like [Instructables](http://www.instructables.com/index) for project ideas. Surprisingly, all the DIY sun jar guides I could find centered around hacking up a pre-built solar garden light and stuffing the guts into a jar.

That didn't sound like any fun to me. This had to be a really simple circuit. Why not build it from scratch and learn something along the way? I decided that would be my project.

Designing the circuit
---------------------

My first step was reading about battery-charging circuits. I wanted this to be a simple project, and I knew I'd be working with a low current from a solar panel, so  [trickle-charging](http://en.wikipedia.org/wiki/Battery_charging#Trickle) seemed like the best option. After Googling around for a bit, I settled on this circuit configuration:

[![circuit](/images/sunjar_circuit.png)](https://www.circuitlab.com/circuit/wn826n/sun-jar/)

Click on the circuit image above to visit the CircuitLab page and read a full explanation of how it works.

Building the circuit
--------------------

The next step was to start spec'ing out the parts. Most LEDs have a forward voltage — also called a [voltage drop](http://en.wikipedia.org/wiki/LED_circuit) — of around 2V, with some blues [dropping as much as 3.8V](http://www.oksolar.com/led/led_color_chart.htm). This meant I needed a battery of 3V or more. A normal AA or AAA cell is about 1.2V, and I had some rechargeables around, so I strung 3 AAAs in series and made myself a 3.6V battery pack.

To trickle charge a 3.6V battery I needed a solar panel that could produce a higher voltage than that and also would fit in the lid of a jar. After a lot of searching I found these inexpensive [5V solar "badges" ](http://www.adafruit.com/products/700) from Adafruit. 

[![solar badge front](/images/solar_badge_front.jpeg)](http://www.adafruit.com/products/700)


Next, I built the circuit on a breadboard to test it out. Here's a video of me demonstrating the light turning on when the solar panel gets dark:

<object width="640" height="360"><param name="movie" value="http://www.youtube.com/v/ASY-5kZcReo?hl=en_US&amp;version=3&amp;rel=0"></param><param name="allowFullScreen" value="true"></param><param name="allowscriptaccess" value="always"></param><embed src="http://www.youtube.com/v/ASY-5kZcReo?hl=en_US&amp;version=3&amp;rel=0" type="application/x-shockwave-flash" width="640" height="360" allowscriptaccess="always" allowfullscreen="true"></embed></object>

I could tell right away that the battery would light the LED and voltage from the solar panel would control the transistor, but it took some time to test charging the battery. I observed with a multimeter that the battery voltage was higher after several hours in the sun, but I also left the breadboard in a sunny window for a couple of weeks as a real test, and the LED kept lighting up every night.

Fitting it in a jar
-------------------

Now that I'd demonstrated that the circuit worked, the next step was to build a prototype. The 3AAA battery pack was too big to fit in a jar, so I went searching for a better battery. I found these cool 3.6V [rechargeable lithium ion coin cells](https://www.sparkfun.com/products/10319)

![rechargable coin cell](https://lh4.googleusercontent.com/-fxoSB3m2i_A/UVjcnCcdBoI/AAAAAAAATFs/V8HB8NtdCTg/s545/10319-00a.jpg)

at Sparkfun which ended up being perfect, so I ordered several of them along with some matching [holders](https://www.sparkfun.com/products/8863).

![holder](https://lh5.googleusercontent.com/-R_lP45tDXJY/UVjcnJ6GtfI/AAAAAAAATFw/Ffi2GZ7eG7E/s545/08863-03-L.jpg)

Here's where ordering stuff online can bite you. I didn't realize until they arrived that the holders are only the positive contact for the battery. They're intended for use on a PCB where a solder pad on the board provides the negative contact. Bummer! So I had to wait a few more days for some [breakout boards](https://www.sparkfun.com/products/10495) to arrive.

![breakout board](https://lh5.googleusercontent.com/-z2Wej6BZA8g/UVjcnDNqfjI/AAAAAAAATF0/805fKg0V1hY/s545/10495-01.jpg)

Once I received the breakout boards, I soldered one up and used it to replace the 3AAA battery pack in my window circuit. I let that run for several more weeks as a battery test.

Lithium ion batteries are really sensitive to overcharging, and you can easily ruin them that way. Most LI-charging circuits employ circuitry to cut off the charger once the battery has reached a certain float voltage. I didn't think too much overcharging would happen in my circuit, so I decided to gamble $3 and find out what would happen. So far everything seems to work fine. The LED lights up brightly after sunny days and runs for several hours. On overcast days it's somewhat dimmer and doesn't last as long. I haven't measured a battery voltage above the 3.6V rating, so I don't think it's overcharging. I guess it could be different in areas that get more intense direct sunlight for longer periods of time.

Making the first real prototype
-------------------------------

With a working circuit and a smaller battery I next built the actual prototype sun jar. Most commercial sun jars put the solar panel underneath a hinged glass lid. Since I had weatherproof solar panels that could go on the outside of a jar, I decided to go for a slightly different look, and I ordered these [8-ounce Ball Jars](http://www.amazon.com/gp/product/B008586UJY/ref=oh_details_o04_s00_i00?ie=UTF8&psc=1) from Amazon.

![jar](https://lh6.googleusercontent.com/-vBlMKgWrqxI/UVjdu70DGHI/AAAAAAAATGE/-DhXuIj5DFk/s500/url.jpeg)

I also picked up some [frosted glass spray](http://www.amazon.com/gp/product/B0009XCKBA/ref=oh_details_o03_s00_i00?ie=UTF8&psc=1).

![frosted glass spray](https://lh5.googleusercontent.com/-X6D4e6A4xsQ/UVjdvN9ByiI/AAAAAAAATGM/xJXylRtFUFY/s544/71-BZrK03tL._SL1500_.jpg)

I soldered a couple of wires to the solder pads on the back of the solar panel and drilled a hole in the jar lid. I routed the wires through the hole and then adhered the panel to the lid with some [RTV Silicone](http://www.amazon.com/gp/product/B0002UEPVI/ref=oh_details_o09_s00_i00?ie=UTF8&psc=1) sealant. 

![rtv](https://lh6.googleusercontent.com/-8DmflriP_C4/UVjduznTTRI/AAAAAAAATGI/6IVmMYqaB3k/s500/51qCJy1QWTL.jpg)

This stuff takes patience because you have to clamp it overnight, but it makes a good weatherproof seal, so the finished jar can be left outside.

![clamped lids](https://lh5.googleusercontent.com/-ouuDbEpzcLk/UVjUGWGjR5I/AAAAAAAATEo/BMN18G1s4GU/s730/940BF1B5-BE37-47FB-A732-C026EC78311A.JPG)

I took the other circuit components off the breadboard and soldered them down to a little piece of [protobard](http://www.amazon.com/gp/product/B008CG62DI/ref=oh_details_o00_s01_i00?ie=UTF8&psc=1). Once the silicone had cured on the lid I wired the solar panel to the rest of the board. 

![completed board](https://lh4.googleusercontent.com/-1Xtv22QMMng/UVjTyfhashI/AAAAAAAATEc/Qrp0360izFQ/s730/7BDDAF8D-E158-4A7F-AC00-D77D46873F66.JPG)

Adhering the board to the underside of the jar lid proved pretty tricky. I couldn't get silicone to hold, so I went to hot glue. It seemed to work at first, but then popped apart a couple of hours later. These jars are made for food, and it turns out the non-stick stuff they coat the underside of the lid with is pretty damn non-stick. The third time was the charm, though. [Gorilla glue](http://www.amazon.com/Gorilla-Glue-50004-Adhesive-4-Ounces/dp/B0001GAYRC/ref=sr_1_1?ie=UTF8&qid=1364768335&sr=8-1&keywords=gorilla+glue) held really well.

The jars actually look pretty nice after being frosted with the spray. Here's one complete jar and a couple I'm still working on.

![frosted jars](https://lh3.googleusercontent.com/-mpbF5m9LLkU/UVjXSKtyvAI/AAAAAAAATE0/9TCkA9CqbM0/s730/98E1C46D-9F6F-4DCA-A0D1-20C9ECE52450.JPG)

Here's how the first completed jar looks in the dark. Pretty good if I do say so myself. 

![lit jar](https://lh6.googleusercontent.com/-KTQSJQDCUvk/UVjXSGFdNfI/AAAAAAAATE4/Dbla8NtCHlo/s730/316CC0CC-F068-41C0-BDC5-331349D7BA0C.JPG)

Designing a custom PCB
----------------------

Building the sun jar was really fun, and I want to make a lot more with different size jars and different color LEDs, so it would be really nice to get this circuit on a PCB. That way I could just drop in the parts and solder, rather than buying more battery breakout boards and cobbling everything together on protobard.

First I downloaded [Eagle](http://www.cadsoftusa.com/download-eagle/?language=en). It seemed to be the DIY community standard and Sparkfun has [open source Eagle libraries](https://github.com/sparkfun/SparkFun-Eagle-Libraries) that include the battery holder wanted to use.

I used these two really great tutorials, also by Sparkfun, to first create the circuit schematic and then the PCB layout.

[Eagle: Schematics](https://www.sparkfun.com/tutorials/108)
![screenshot of my schematic](https://lh4.googleusercontent.com/-boGZ6TuJkRw/UVjr1t3Wi_I/AAAAAAAATGU/7S-abtDulaE/s785/Screen%2520Shot%25202013-03-31%2520at%252010.04.18%2520PM.png)

[Eagle: PCB Layout](https://www.sparkfun.com/tutorials/109)
![screenshot of my board layout](https://lh5.googleusercontent.com/-dk-xBSGJ6Hk/UVjr2PLp8tI/AAAAAAAATGc/Z2R7y9SpmoI/s783/Screen%2520Shot%25202013-03-31%2520at%252010.05.06%2520PM.png)

If you'd like to play with this design, you can [fork it on Github](https://github.com/mattmanning/sunjar).

The tutorials were really great and comprehensive. I didn't have to do much Googling outside of them to figure things out. The only real issues were that the Windows-oriented keyboard shortcuts didn't work for me on OS X, so I had to dig through the menus for a couple of things, but it wasn't too bad.

Fabricating the PCB
-------------------

With the layouts done and [Gerber files](http://en.wikipedia.org/wiki/Gerber_format) generated, I needed a place to get the PCB printed. Adafruit has some good reviews and recommendations for board houses, but even the cheapest of those charge a $35 setup fee and it looked like I might have to spend time on the phone to get the order done.

Just when I started to feel discouraged, Sparkfun came to the rescue again with their brilliant [BatchPCB](https://batchpcb.com/faq) service. You simply upload a zip of your Gerber files and it does some quick checks to verify the files. Once they clear, your board shows up on the Marketplace view where you can order it. The set up fee is only $10, so I've ordered a prototype of [my board](https://www.batchpcb.com/pcbs/112559) for under $20 including shipping.

![image of board from BatchPCB marketplace](https://lh6.googleusercontent.com/-RsTLMC2PiHI/UVjXxE2RPmI/AAAAAAAATFA/S2ZNB8S02jI/s700/BatchPCB+%23112559.png)

It'll take a few weeks for the first board to get to me, but if it works, I'll post an update here in case anyone wants to buy one. I think this might also make a fun "learn to solder" kit since it only has a few parts and they're all of the through-hole type. If you'd be interested in buying a kit of these parts including a PCB, please leave a comment here or let me know at matt.manning@gmail.com.