import webapp2

from models.questions import QuestionRepository


class Update(webapp2.RequestHandler):
    URL = '/update_ids'

    def get(self):
        ids_of_items_to_update = [int(items_id) for items_id in self.request.get_all('id')]

        if ids_of_items_to_update:
            QuestionRepository.update_items(ids_of_items_to_update)

        self.response.headers['Content-Type'] = 'text/plain'
        self.response.out.write('OK')

