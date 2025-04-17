extends Node

#------------------
#
#Prelude Dialogue
#
#------------------

#Dialogue for when Mynra first spawns into Oblivion
const mynra_arrives: Array = [
	{"speaker": "Scythio", "text": "Where... where am I?"}
]

#Dialogue for when Mynra first meets Scythio in Oblivion
const mynra_meets_scythio_0: Array = [
	{"speaker": "Scythio", "text": "Hello there, I am Scythio, the Son of Life and Death. Welcome to Oblivion, the Heaven of the Gods."},
	{"speaker": "Mynra", "text": "Heaven of the Gods… I… I’m dead?"},
	{"speaker": "Scythio", "text": "Yes, same as the rest of us."},
	{"speaker": "Mynra", "text": "The rest of us? How many... who are you?"},
	{"speaker": "Scythio", "text": "I am Scythio, and I was the first to arrive, at least, from what I can tell. I sensed no other souls here at the time at least, though I've no clue how big Oblivion actually is, so who knows…."},
	{"speaker": "Scythio", "text": "Soon after I arrived, Jay followed, and then Orion after him. And now, here you are, and by my count, that is everyone. I don’t remember very much at all, but I do still recall there being only four gods, each with a child."},
	{"speaker": "Mynra", "text": "I don’t even remember that. All I can remember is my name, and my heritage…. Speaking of, I am Mynra, the Daughter of Hope and Despair."},
	{"speaker": "Scythio", "text": "Well, it’s a pleasure to meet you Mynra, even if it is under rather grim circumstances."},
	{"speaker": "Scythio", "text": "So you don’t remember anything either? Damn, we’ve been trying to find a way to contact our parents, to no avail, but even if we could, well-"},
	{"speaker": "Mynra", "text": "Wait, why are you trying to reach out to the Gods?"},
	{"speaker": "Scythio", "text": "Well, we were called Immortals for a reason Mynra: we aren’t supposed to die, and never should, at least, not by natural causes.
	Which means that its very likely that something killed us… somehow. "},
	{"speaker": "Scythio", "text": "All four of us have been smote by something in The Grand Infinity, and if it hunts still, its not unlikely that the Gods would be next
	on its list of targets."},
	{"speaker": "Mynra", "text": "So you’re trying to find a way to warn them."},
	{"speaker": "Scythio", "text": "Yes, exactly, and though our efforts have so far been in vain, but we are trying still.
	Problem is, even if we do find a way to contact them, it won’t mean much if we can’t even tell them what it is that killed us."},
	{"speaker": "Mynra", "text": "I suppose, though warning them of anything is probably a good idea. In the very least, we can make sure they know that there's a threat to the Pantheon."},
	{"speaker": "Scythio", "text": "I've a funny feeling they probably already know there's a threat to the Pantheon."},
	{"speaker": "Mynra", "text": "Really? What makes you say tha- Oh, right... we're dead. I guess they would probably notice if their children up and vanished from the face of Infinity."},
	{"speaker": "Scythio", "text": "Exactly, which is why we need information if we want contacting them to mean anything, and we've yet to gain any. Memory loss is... well, I guess I'm preaching to the choir here, huh?"},
	{"speaker": "Mynra", "text": "Yeah, although, you know… you do seem familiar. Do you think it's possible that we knew each other in life?"},
	{"speaker": "Scythio", "text": "I think we all probably knew each other before our deaths, but, I will admit, the others never mentioned me seeming familiar."},
	{"speaker": "Mynra", "text": "Yeah, I don’t know, it just feels like-"}
]

#Dialogue for when Mynra and Scythio first meet in Pryd's subhive
const mynra_meets_scythio_1: Array = [
	{"speaker": "Scythio", "text": "Oh, hello there! Sorry, I wasn't expecting to see anyone else here."},
	{"speaker": "Mynra", "text": "Neither was I. Nice to meet you though! I'm Mynra, the Daughter of Hope and Despair."},
	{"speaker": "Scythio", "text": "Oh, you're Wyrndia's daughter! It's nice to meet you too, I'm Scythio, the Son of Life and Death. Kyrovoy's my Father."},
	{"speaker": "Mynra", "text": "Yeah I figureed, given the whole \"Son of Life and Death\" thing, haha."},
	{"speaker": "Mynra", "text": "So, what brings you to Esvia?"},
	{"speaker": "Scythio", "text": "Um, well, I kind of made my first creation, and it's kind of sort of... infested this place."},
	{"speaker": "Mynra", "text": "Wait, you made a creation? You're Father allowed you to create?"},
	{"speaker": "Scythio", "text": "Yeah, encouraged it actually, or atleast, I think he did."},
	{"speaker": "Scythio", "text": "He gave me a spear blessed with the power of Life to help me better harness my abilities, and then just sort of sent me on my way. If he didn't expect me to create with then I'm not so sure why he would've given it to me to begin with."},
	{"speaker": "Mynra", "text": "That's fair I suppose, though you meantioned that your creation has since... \"infested\" this place. That seems unhealthy."},
	{"speaker": "Scythio", "text": "Hence why I'm here with the second gift my father gave me: a scythe imbued with the power of Death. Kind of just need to purge the queen of the hive that has grown here, and then the world's natural order can correct itself."},
	{"speaker": "Mynra", "text": "Huh, well, if you want some help with that my Mom isn't expecting me back for another decade or so. She told me to go preserve Ma'at, and this certainly counts."},
	{"speaker": "Scythio", "text": "Oh that'd be fantastic, I really appreciate it!"},
	{"speaker": "Scythio", "text": "The Hive shouldn't be too far, just a little bit down South."}
]

const mynra_meets_scythio_2: Array = [
	{"speaker": "Scythio", "text": "There it is, entrance to hive."},
	{"speaker": "Mynra", "text": "It's underground?"},
	{"speaker": "Scythio", "text": "Yeah, the queens are smart and know that most real threats to them would lurk above ground, so underground is the safest place to build."},
	{"speaker": "Mynra", "text": "Just curious, but what \"threats\" exist for them?"},
	{"speaker": "Scythio", "text": "Um, well there's us and the Gods, and we live above ground, haha!"},
	{"speaker": "Scythio", "text": "Admittedly, I've not seen a natural predator for them here, which is a big reason why we need to excise them from Esvia. They're kind of wrecking the whole natural order of things here."},
	{"speaker": "Mynra", "text": "Right... welp, down we go!"}
]

const mynra_and_scythio_0: Array = [
	{"speaker": "Mynra", "text": "Woah... I won't lie, I was expecting dirt, as is usually what's underground. What is this?"},
	{"speaker": "Scythio", "text": "Yeah, I was shocked when I first came down here too. Junithyrascade explained it to me though."},
	{"speaker": "Scythio", "text": "Apparently, there are some materials that he said reflect light and basically take what they \"see\" and show it back to them."},
	{"speaker": "Mynra", "text": "Right, yeah, I've seen reflective surfaces before like water and xuridium, but this... this is something else entirely."},
	{"speaker": "Mynra", "text": "Wow... sorry, I've only ever seen myself in water before, but this just feels so different. It's like I can actually see what I look like."},
	{"speaker": "Scythio", "text": "Yeah, I get it, it was very unsettling for me when I first saw my own reflection so clearly."},
	{"speaker": "Mynra", "text": "Huh..."},
	{"speaker": "Scythio", "text": "If you don't mind, you can admire yourself later, we do need to get going. There's a few other hives I need to deal with."},
	{"speaker": "Mynra", "text": "Yeah, okay, let's go."}
]

const mynra_and_scythio_1: Array = [
	{"speaker": "Scythio", "text": "No, wait... damn, too late..."},
	{"speaker": "Mynra", "text": "Um, what the hell?!"},
	{"speaker": "Scythio", "text": "Yeah, I probably should've mentioned this, but the arlithon hive mind has a special way of working."},
	{"speaker": "Scythio", "text": "When one of them dies while surrounded by its hivemates, some of them can copy the mutations they had when they died."},
	{"speaker": "Mynra", "text": "Yeah, that would've been useful information to have. At least I know now to avoid killing mutated ones until I absolutely have to."},
	{"speaker": "Scythio", "text": "Probably a good idea, but smiting won't trigger any mutations to spread since, well, they can't copy what they can't even remember."},
	{"speaker": "Mynra", "text": "Also good to know, thanks!"}
]

const mynra_and_scythio_2: Array = [
	{"speaker": "Mynra", "text": "So, if you don't mind me asking, why did you design these... things like this?"},
	{"speaker": "Scythio", "text": "They're called arlithons, and, well, to be quite honest, I wanted to create something unique."},
	{"speaker": "Scythio", "text": "Making a bull with bigger horns or a heshlet with wings just seemed kind of boring."},
	{"speaker": "Scythio", "text": "A lot of creatures in The Grand Infinity evolve and adapt over time through natural selection, so I decided to make something that turned that whole process on its head... and sped it up a tad."},
	{"speaker": "Mynra", "text": "I guess that's fair, but still, aren't you or your Father worried how they'll effect Ma'at?"},
	{"speaker": "Scythio", "text": "Well, yeah, that's why we're here. He explicitly asked me to scatter the seven queens across The Grand Infinity, he said it was the best way to find a real home for them."},
	{"speaker": "Scythio", "text": "I still have to monitor them though of course, and, when they get too out of hand, deal with them, like we're doing today."}
]

const mynra_and_scythio_3: Array = [
	{"speaker": "Mynra", "text": "So, why would the queen want to build her hive out of this stuff? I imagine it is not easy to come by as I've never seen it before, so I don't think this was an accident."},
	{"speaker": "Scythio", "text": "Yeah, I've thought about that too. Gried likes to collect cyrstals and gems as well, but she's a lot less picky about she finds, just so long as it's shiny."},
	{"speaker": "Scythio", "text": "As for how common this material is... it's not common at all, in fact, as far as I can tell, outside of this hive, it doesn't exist."},
	{"speaker": "Mynra", "text": "Wait... what?"},
	{"speaker": "Scythio", "text": "I've looked around Esvia, and I mean REALLY looked, but I can't find anything that reflects as well as this stuff does. On top of that, her workers don't bring in the crystalline itself."},
	{"speaker": "Scythio", "text": "What they bring in is some kind of raw material that they must somehow refine into what they actually use for the hive. So, yeah, she does it on purpose, but I don't really know why."},
	{"speaker": "Mynra", "text": "Maybe she just really likes to look her own reflection, haha!"},
	{"speaker": "Scythio", "text": "He, yeah, maybe..."}
]

const mynra_and_scythio_4: Array = [
	{"speaker": "Scythio", "text": "Okay, Pryd's throne room should be just ahead of us."},
	{"speaker": "Mynra", "text": "So, what's the plan then, how do we kill her?"},
	{"speaker": "Scythio", "text": "It's simple: we don't."},
	{"speaker": "Mynra", "text": "Um... what?"},
	{"speaker": "Scythio", "text": "Like I said, we're trying to find a place in The Grand Infinity for the arlithons to exist. There's only seven queens, so we can't go killing them."},
	{"speaker": "Mynra", "text": "...Okay..."},
	{"speaker": "Mynra", "text": "Well, in that case, what's the plan, how do we NOT kill her?"},
	{"speaker": "Scythio", "text": "We just need to fein her. The queens are strong, but they weren't built for combat, that's what the rest of the hive is for."},
	{"speaker": "Scythio", "text": "If we wear her out, then the rest of the hive should fall since there's nothing giving them orders any more, and then we can safely transfer her to a new world."},
	{"speaker": "Mynra", "text": "What if the hive DOESN'T go down when she does?"},
	{"speaker": "Scythio", "text": "We fought our way in here, we can fight our way out, but trust me, they should fall when she's down, at least, that's what happened when I moved Glutonee."},
	{"speaker": "Mynra", "text": "Alright, if you say so. Let's do this."}
]

const mynra_and_scythio_5: Array = [
	{"speaker": "Scythio", "text": "WHAT IN THE NAME OF MA'AT IS THAT?!?!?!"},
	{"speaker": "Mynra", "text": "Um... Scythio?"},
	{"speaker": "Scythio", "text": "Forget everything I said, that thing is NOT Pryd and we need to kill her, NOW!"},
	{"speaker": "Mynra", "text": "What?! Then what is it?!"}
]

const mynra_and_scythio_6: Array = [
	{"speaker": "Scythio", "text": "Well... that wasn't what I was expecting at all. At least I was right about the whole \"rest of the hive falls too\" thing though, hehe!"},
	{"speaker": "Mynra", "text": "What was that thing?"},
	{"speaker": "Scythio", "text": "Well, like I mentioned before, arlithons evolve quite a bit differently than the rest of The Grand Infinity's creations."},
	{"speaker": "Mynra", "text": "Right..."},
	{"speaker": "Scythio", "text": "And the queens are pretty smart from what I've seen."},
	{"speaker": "Mynra", "text": "Uh huh..."},
	{"speaker": "Scythio", "text": "...Yeah, I-I think that Pryd may have sacrificed some of her hive on purpose as a way to feed one specific warrior and turn him into a disciple of sorts."},
	{"speaker": "Scythio", "text": "More specifically, a disciple that was able to run an entire hive by itself, which, before only a few moments ago, I did not think was possible without a queen."},
	{"speaker": "Mynra", "text": "Excuse me?!"},
	{"speaker": "Scythio", "text": "Yeah, this is bad. I need to go report back to my Father and check the other hives. If the other queens have figured this out then Ma'at knows how many disciples there are or how far they've spread."},
	{"speaker": "Scythio", "text": "Thank you for all of the help Mynra, I really do appreciate it. It was great meeting you, and I really do hate to just run out like this, but-"},
	{"speaker": "Mynra", "text": "No, you're fine, I get, go let your Father know, I can search the hive and make sure there aren't any other \"disciples,\" and if you ever need any help on a future hive, don't be afraid to ask."},
	{"speaker": "Scythio", "text": "Thank you, thank you so much. Again, it was great meeting you!"},
	{"speaker": "Mynra", "text": "Absolutely, and it was great meeting you too Scythio! Goodluck with, well, everything."},
	{"speaker": "Scythio", "text": "Thank you, Ma'at knows I'll need it."}
]

const mynra_meets_scythio_3: Array = [
	{"speaker": "Mynra", "text": "*Gasp!*"},
	{"speaker": "Scythio", "text": "Mynra? Mynra! Are you okay?!"},
	{"speaker": "Mynra", "text": "I'm fine, I just... I just had a memory, the-"},
	{"speaker": "Scythio", "text": "Memory of when we first met, I had it too! My Father, my scythe and spear, and my first creation: the arlithons. "},
	{"speaker": "Mynra", "text": "Venturing into Pryd's hive and finding Subjugation. You saw it all too?"},
	{"speaker": "Scythio", "text": "Yes, every moment, I was like I was living it again for the first time. Mynra, I think we just figured out how to remember our past."},
	{"speaker": "Mynra", "text": "What?"},
	{"speaker": "Scythio", "text": "You mentioned that I seemed familiar to you, like you could recognize me almost, and then we went into that memory."},
	{"speaker": "Scythio", "text": "I don't fully understand how you triggered it, but I think this place allows us to recall shared experiences. Memories that more than just one of us have, almost like we're reminding each other of the past."},
	{"speaker": "Mynra", "text": "In that case, we need to find the others. If we all died to the same thing, it's possible being together will trigger us to remember how it happened."},
	{"speaker": "Scythio", "text": "Exactly! You stay here, just in case, Ma'at forbid, someone else enters Oblivion."},
	{"speaker": "Scythio", "text": "I'll go round up the rest of the Immortals and meet you back here and we'll see if we can't trigger something."},
	{"speaker": "Mynra", "text": "Okay, sounds good, just be qu-"},
	{"speaker": "Scytio", "text": "Mynra?"},
	{"speaker": "Scythio", "text": "Mynra? Is something wrong?"},
	{"speaker": "Mynra", "text": "...Mom? No... no... why are you... no, Mom, you can't!"},
	{"speaker": "Scythio", "text": "Mynra, can you see the Gods?!"},
	{"speaker": "Mynra", "text": "Mom... why would you go there... you can't go there, Mom, what are you doing...?"},
	{"speaker": "Scythio", "text": "Mynra! Tell me, what do you see?!"},
	{"speaker": "Mynra", "text": "..."},
	{"speaker": "Mynra", "text": "The Thirteenth Creation Hunts..."},
]
