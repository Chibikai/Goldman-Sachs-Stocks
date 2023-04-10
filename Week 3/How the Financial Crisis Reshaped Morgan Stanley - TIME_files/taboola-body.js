function checkFlags() {
    let adblockMeta = document.querySelector('#page-gtm-values > .keyvals[data-ad_tags*="adblock"]');
    if (adblockMeta !== null) return true;
    let exclusion = ['section-charter','collection-article','"collection"'];    
    if ( typeof LUX !== 'undefined' && typeof LUX.label !== 'undefined' && LUX !== null && LUX.label !== null)  {
        if (exclusion.includes(LUX.label)) return true;
    }
    let targeting = document.querySelector('script[data-tgxtargeting]');
    if (targeting !== null) {   
        targeting= decodeURIComponent(targeting.getAttribute('data-tgxtargeting'));
        for (let i in exclusion) {
            if (targeting.includes(exclusion[i])) return true;
        }
    }   
    return false;
}
if (!checkFlags()) { 
   window._taboola = window._taboola || [];
   _taboola.push({
     mode: 'thumbnails-a',
     container: 'taboola-below-article-thumbnails',
     placement: 'Below Article Thumbnails',
     target_type: 'mix'
   });
}
