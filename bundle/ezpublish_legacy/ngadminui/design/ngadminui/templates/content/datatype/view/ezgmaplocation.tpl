{if is_unset( $width )}
    {def $width=500}
{/if}
{if is_unset( $height )}
    {def $height=280}
{/if}

{* Make sure to normalize floats from db  *}
{def $latitude  = $attribute.content.latitude|explode(',')|implode('.')
     $longitude = $attribute.content.longitude|explode(',')|implode('.')}
{run-once}
<script type="text/javascript" src="//maps.google.com/maps/api/js?key={ezini('GMapSettings', 'ApiKey', 'ngadminui.ini')}"></script>
<script type="text/javascript">
{literal}
function eZGmapLocation_MapView( attributeId, latitude, longitude )
{
	var zoommax = 13;
	
	if( latitude && longitude )
	{
		var startPoint = new google.maps.LatLng( latitude, longitude );
		var zoom = zoommax;
		
	}
  else
  {
      var startPoint = new google.maps.LatLng( 0, 0 );
      var zoom = 0;
  }
  var map = new google.maps.Map( document.getElementById( 'ezgml-map-' + attributeId ), { center: startPoint, zoom : zoom, mapTypeId: google.maps.MapTypeId.ROADMAP } );
	var marker = new google.maps.Marker({ map: map, position: startPoint });
}
{/literal}
</script>
{/run-once}
{if $attribute.has_content}
<script type="text/javascript">
if ( window.addEventListener )
    window.addEventListener('load', function(){ldelim} eZGmapLocation_MapView( {$attribute.id}, {first_set( $latitude, '0.0')}, {first_set( $longitude, '0.0')} ) {rdelim}, false);
else if ( window.attachEvent )
    window.attachEvent('onload', function(){ldelim} eZGmapLocation_MapView( {$attribute.id}, {first_set( $latitude, '0.0')}, {first_set( $longitude, '0.0')} ) {rdelim} );
</script>
<div class="block">
<label>{'Latitude'|i18n('extension/ezgmaplocation/datatype')}:</label> {$latitude}
<label>{'Longitude'|i18n('extension/ezgmaplocation/datatype')}:</label> {$longitude}
  {if $attribute.content.address}
    <label>{'Address'|i18n('extension/ezgmaplocation/datatype')}:</label> {$attribute.content.address}
  {/if}
</div>
<label>{'Map'|i18n('extension/ezgmaplocation/datatype')}:</label>
<div id="ezgml-map-{$attribute.id}" style="width: {$width}px; height: {$height}px;"></div>
{/if}