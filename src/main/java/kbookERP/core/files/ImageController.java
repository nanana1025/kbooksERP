package kbookERP.core.files;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import kbookERP.util.vo.ImageBrowserDaoImpl;


public class ImageController {

    private ImageBrowserDaoImpl imageBrowser;

//
//    @RequestMapping(value = {"/imageBrowser/image"}, method = RequestMethod.GET)
//    public @ResponseBody byte[] getImage(@RequestParam String path) throws IOException {
//        return imageBrowser.getImage(path);
//    }
//
//    @RequestMapping(value = {"/imageBrowser/read"}, method = RequestMethod.POST)
//    public @ResponseBody List<ImageBrowserEntry> read(String path) {
//        return imageBrowser.getList(path);
//    }
//
//    @RequestMapping(value = {"/imageBrowser/thumbnail"}, method = RequestMethod.GET)
//    public @ResponseBody byte[] thumbnail(String path) throws IOException {
//        return imageBrowser.getThumbnail(path);
//    }
//
//    @RequestMapping(value = "/imageBrowser/upload", method = RequestMethod.POST)
//    public @ResponseBody ImageBrowserEntry upload(@RequestParam MultipartFile file, @RequestParam String path) throws IllegalStateException, IOException {
//        if (file != null) {
//            return imageBrowser.saveFile(file, path);
//        }
//        return null;
//    }
//
//    @RequestMapping(value = "/imageBrowser/create", method = RequestMethod.POST)
//    public @ResponseBody ImageBrowserEntry create(@RequestParam final String name, @RequestParam final String type, @RequestParam String path) throws IOException {
//        ImageBrowserEntry entry = new ImageBrowserEntry() {{
//            setName(name);
//            setType(type);
//        }};
//
//        imageBrowser.create(path, entry);
//        return entry;
//    }
//
//    @RequestMapping(value = "/imageBrowser/destroy", method = RequestMethod.POST)
//    public @ResponseBody ImageBrowserEntry destroy(@RequestParam final String name, @RequestParam final String type, @RequestParam String path) throws IOException {
//        ImageBrowserEntry entry = new ImageBrowserEntry() {{
//            setName(name);
//            setType(type);
//        }};
//
//        imageBrowser.destroy(path, entry);
//        return entry;
//    }
}
