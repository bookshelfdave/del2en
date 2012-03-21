### DUDE THIS IS SOME CRAPPY RUBY!
require 'nokogiri'
## REQUIRES RUBY 1.9!!!

def clean(s)
  if s.nil? or s == "" then
    return ""
  end

  ## yeah... look at this great code right here!
  s.gsub!("&","and")
  s.gsub!("<"," ")
  s.gsub!("<"," ")
  s.gsub!('\n',' ')
  s.gsub!('\t',' ')
  s.gsub!('\r',' ')
  s.gsub!('"',' ')
  s.gsub!('\'',' ')
  s.gsub!('\`',' ')
  s.gsub!('/',' ')  
  s.strip!
  if s.length > 254
    s.slice!(0,254)
  end
  fixed = ""  
  s.each_byte do |c|
    if c < 125 then
      fixed << c
    end
  end
  fixed
end

doc = Nokogiri::XML(File.open("c:\\delbackup.xml")) 
bookmarks = doc.xpath("//post")

out = <<END
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE en-export SYSTEM "http://xml.evernote.com/pub/evernote-export.dtd">
<en-export export-date="20101230T134846Z" application="Evernote/Windows" version="4.1">
END
puts out
bookmarks.each do |bookmark|
  href = bookmark.attributes["href"].to_s.encode("UTF-8")
  tags = bookmark.attributes["tag"].to_s.encode("UTF-8")
  title = bookmark.attributes["description"].to_s.encode("UTF-8")
  if title.nil? or title == "" then
    title = "Untitled"
  end
  datetime = bookmark.attributes["time"].to_s

    #2010-12-16T13:57:40Z
  date = datetime.split("T")[0]
  time = datetime.split("T")[1]
  date = date.split("-").join
  time = time.split(":").join
  title = clean(title)
  notes = bookmark.attributes["extended"].to_s.encode("UTF-8")

  tagtext = tags.to_s.split(" ").map {|tag| "<tag>#{clean(tag)}</tag>"}.join(" ")
  #20101230T124753Z
  content =<<END
<![CDATA[<?xml version="1.0" encoding="UTF-8"?>

		<!DOCTYPE en-note SYSTEM "http://xml.evernote.com/pub/enml2.dtd">		
		<en-note style="word-wrap: break-word; -webkit-nbsp-mode: space; -webkit-line-break: after-white-space;">
		#{title}
		<div><br/></div>
		<div><a href="#{href}">#{href}</a></div>
                <div>#{notes}</div>
		</en-note>]]>
END

  note = "
<note>
   <title>#{title}</title>
   <content>#{content}</content>
   <created>#{date}T#{time}</created>
   <updated>#{date}T#{time}</updated>
   #{tagtext}
</note>
"

puts note
#puts title
end


puts "</en-export>"
