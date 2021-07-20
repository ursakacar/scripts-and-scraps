/*
This script is used for validating that the redirects from https://gitlab.com/eyeo/specs/spec/-/blob/master/spec/adblockplus.org/documentation-link.md work

As I use it sporadically I do not keep it up-to-date so some links might be outdated.

Data
doc-redirect-links.json : the 'main' file with majority of links
doc-language-links.json : I used this for testing the link resolution for different languages in an effort to keep the main file at least a little decluttered :)
doc-problem-links,json : links that fail for various reasons and I never bothered to take a look what's going on, but still wanted to keep track of them.
*/

const https = require('https')
const fs = require('fs')

const baseUrl = 'https://adblockplus.org/redirect?link='
// change doc-redirect-links to whichever file you want the script to use
const redirectLinksString = fs.readFileSync('doc-redirect-links.json')
const redirectLinks = JSON.parse(redirectLinksString)

redirectLinks.forEach((redirectLink) => {
  const sourceUrl = baseUrl + redirectLink.source
  checkUrlRedirect(sourceUrl, redirectLink.destination).then((responseString) => {
    console.log(`${redirectLink.source} ${responseString} \n`)
  }).catch((responseString) => {
    console.log(`${redirectLink.source} ${responseString} \n`)
  })
})

function checkUrlRedirect(source, destination) {
  return new Promise((resolve, reject) => {
    https.get(source, (response) => {
      if (response.statusCode > 300 && response.statusCode < 400) {
        resolve(checkUrlRedirect(response.headers.location, destination))
      } else {
        if ( source === destination && response.statusCode === 200) {
          resolve(`PASSED`)
        } else {
          reject(`FAILED \n-> Redirect failed at ${source} with response code: ${response.statusCode} \n-> Expected destination ${destination}`)
        }
      }
    })
  })
}
