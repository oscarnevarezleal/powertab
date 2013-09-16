currentTab = null

class PageEvents
	constructor: ()->

	setCurrentTab: (tab) ->		
		chrome.tabs.update(tab.id, { active: true })
	duplicateTab: (contextData) ->		
		chrome.tabs.create ({url: contextData.pageUrl})
	newTab: (contextData) ->		
		chrome.tabs.create ({url: contextData.linkUrl})
	closeTabsToTheLeft: (currentTab, contextData) ->
		chrome.tabs.query({ active : false }, (tabs) ->
			for tab, i in tabs
				chrome.tabs.remove(tab.id) if tab.index < currentTab.index
		)
	closeTabsToTheRight: (currentTab, contextData) ->
		chrome.tabs.query({ active : false }, (tabs) ->
			for tab, i in tabs
				chrome.tabs.remove(tab.id) if tab.index > currentTab.index
		)
	clipboardTabUrls: () ->
		text = ""

		chrome.tabs.query({ active : false }, (tabs) ->
			
			for tab, i in tabs
				console.log(tab.url)				
				text+= tab.url+"\t"
			
			chrome.tabs.query({ active : true }, (tabs) ->
				
				for tab, i in tabs
					console.log(tab.url)
					text+= tab.url+"\t"

				console.log("Final clipboard content = (" + text + ")")

				copyDiv = document.createElement('div')
				copyDiv.contentEditable = true
				document.body.appendChild(copyDiv)
				copyDiv.innerHTML = text
				copyDiv.unselectable = "off"
				copyDiv.focus()
				document.execCommand('SelectAll')
				document.execCommand("Copy", false, null)
				document.body.removeChild(copyDiv)
			)
		)

		true



instance = new PageEvents()

# The onClicked callback function.
onClickHandler = (info, Tab) ->

 chrome.tabs.getCurrent (Tab) ->
	currentTab = Tab

	switch info.menuItemId
		when 'newtab' then instance.newTab(info) or instance.setCurrentTab(currentTab)
		when 'duplicate' then instance.duplicateTab(info)
		when 'closelefttabs' then instance.closeTabsToTheLeft(currentTab, info)
		when 'closerighttabs' then instance.closeTabsToTheRight(currentTab, info)
		when 'copyurltabs' then instance.clipboardTabUrls()

chrome.contextMenus.onClicked.addListener onClickHandler

# Set up context menu tree at install time.
chrome.runtime.onInstalled.addListener ->  
 
  # Create a parent item and children.
  chrome.contextMenus.create
    contexts : ["link"]
    title: "Open in background tab"
    id: "newtab"

  chrome.contextMenus.create
    contexts : ["page"]
    title: "Duplicate this tab"
    id: "duplicate"

  chrome.contextMenus.create
    contexts : ["page"]
    title: "Close tabs to the left"
    id: "closelefttabs"

  chrome.contextMenus.create
    contexts : ["page"]
    title: "Close tabs to the right"
    id: "closerighttabs"

  chrome.contextMenus.create
    contexts : ["page"]
    title: "Copy tabs urls"
    id: "copyurltabs"

@.pageEvents = instance