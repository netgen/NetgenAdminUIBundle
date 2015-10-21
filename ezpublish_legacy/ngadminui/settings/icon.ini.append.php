<?php /* #?ini charset="utf-8"?

[IconSettings]

# Where to look for icons, relative to eZ Publish

Repository=extension/ngadminui/design/ngadminui/images/icons

# Which theme to use as current for all icon types
# If you wish to have a different theme per type you
# can set this variable in the INI group for the type.
# Wanted size of icons, the size is not checked and is expected
# to be just a string which should be a directory in the theme
# Defined sizes, each size refers to the name of the subdirectory
# of the icon theme. If the name contains two numbers with an
# x in between it will be considered to be the width and height
# of the icon, if not no size is will be given

Sizes[huge]=128x128
Sizes[large]=48x48
Sizes[normal]=32x32
Sizes[small]=16x16

Sizes[whiteLarge]=48x48;48x48/white
Sizes[whiteNormal]=32x32;32x32/white
Sizes[whiteSmall]=16x16;16x16/white

[MimeIcons]

Theme=kp
Size=normal

# Default icon if there is no mimetype match
Default=mimetypes/binary.png
# Mapping from a mimetype to it's icon file, the whole filename
# must be included
# Specifying just the group of the mimetype is also possible
MimeMap[]
MimeMap[text]=mimetypes/ascii.png
MimeMap[image]=Picture.png
MimeMap[video]=mimetypes/video.png
MimeMap[audio]=mimetypes/sound.png
MimeMap[application/x-gzip]=mimetypes/tgz.png
MimeMap[application/x-bzip2]=mimetypes/tgz.png
MimeMap[application/x-tar]=mimetypes/tgz.png
MimeMap[application/zip]=mimetypes/tgz.png
MimeMap[application/x-rpm]=mimetypes/rpm.png
MimeMap[application/vnd.ms-powerpoint]=mimetypes/powerpoint.png
MimeMap[application/msword]=mimetypes/word.png
MimeMap[application/vnd.ms-excel]=mimetypes/excel.png
MimeMap[application/pdf]=mimetypes/pdf.png
MimeMap[application/postscript]=mimetypes/pdf.png
MimeMap[text/html]=mimetypes/html.png
MimeMap[video/quicktime]=mimetypes/quicktime.png
MimeMap[video/video/vnd.rn-realvideo]=mimetypes/real_doc.png

[ClassIcons]

Theme=kp
Size=normal

# Default icon if there is no class match
Default=3d.png
# Mapping from a class identifier to it's icon file,
# the whole filename must be included
ClassMap[]
ClassMap[article]=Article.png
ClassMap[comment]=Chat.png
ClassMap[common_ini_settings]=Settings.png
ClassMap[file]=Hard-drive.png
ClassMap[folder]=Folder.png
ClassMap[forum]=Folder.png
ClassMap[forum_message]=Chat.png
ClassMap[forum_reply]=Chat.png
ClassMap[forum_topic]=Chat.png
ClassMap[frontpage]=Layout.png
ClassMap[gallery]=Pictures-alt-2b.png
ClassMap[image]=Picture.png
ClassMap[poll]=Statistic-bar.png
ClassMap[product_review]=Chat.png
ClassMap[review]=Chat.png
ClassMap[template_look]=Settings.png
ClassMap[user]=User.png
ClassMap[user_group]=Users.png
ClassMap[weblog]=Document.png
ClassMap[windows_media]=Video.png
ClassMap[block_edit]=Settings.png
ClassMap[event]=Calendar.png
ClassMap[event_calendar]=Calendar-alt.png
ClassMap[link]=Link.png
ClassMap[video]=Movie.png

ClassMap[ng_article]=Article.png
ClassMap[ng_audio]=Music.png
ClassMap[ng_banner]=Frame-alt.png
ClassMap[ng_banner_video]=Frame-alt.png
ClassMap[ng_blog_post]=Article.png
ClassMap[ng_category]=Folder.png
ClassMap[ng_category_page]=Folder.png
ClassMap[ng_container]=Folder.png
ClassMap[ng_feedback_form]=Autofill.png
ClassMap[ng_frontpage]=Home.png
ClassMap[ng_gallery]=Pictures-alt-2b.png
ClassMap[ng_htmlbox]=Code.png
ClassMap[ng_infobox]=Post-it.png
ClassMap[ng_jsblock]=Code.png
ClassMap[ng_landing_page]=Layout.png
ClassMap[ng_layout]=Layout.png
ClassMap[ng_menu_item]=Ordered-listb.png
ClassMap[ng_news]=Article.png
ClassMap[ng_shortcut]=Path.png
ClassMap[ng_site_info]=Settings.png
ClassMap[ng_video]=Movie-alt.png
ClassMap[ng_video_external]=Movie-alt.png

[ClassGroupIcons]

Theme=kp
Size=normal

# Default icon if there is no class group match
Default=Folder.png
ClassGroupMap[]
ClassGroupMap[content]=Folder.png
ClassGroupMap[users]=Users--alt.png
ClassGroupMap[media]=Playlist.png
ClassGroupMap[setup]=Tools.png

[Icons]

Theme=kp
Size=normal

# Default icon if there is no misc match
Default=Document.png
IconMap[]
IconMap[role]=Users--alt.png
IconMap[section]=Ordered-listb.png
IconMap[translation]=Flag-alt.png
IconMap[pdfexport]=Document.png
IconMap[url]=Globe.png

[FlagIcons]
Repository=extension/ngadminui/design/ngadminui/images/icons
# Which theme to use for flags
Theme=flags-flat
IconFormat=gif
*/ ?>
